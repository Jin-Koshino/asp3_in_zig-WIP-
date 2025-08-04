//
//  TOPPERS/ASP Kernel for Zig Build System (詳細版)
//
//  このビルドスクリプトは、提供されたTOPPERS/ASPのMakefile群
//  (Makefile, Makefile.target, Makefile.core, Makefile.tecsgen) を
//  Zig 0.12.1のビルドシステムに移植したものです。
//
//  元のMakefileは、コード生成、条件付きコンパイル、複数の外部スクリプトの
//  呼び出しなど、複雑なロジックを含んでいます。このbuild.zigは、その構造と
//  依存関係を可能な限り忠実に再現しつつ、Zigビルドシステムのモダンな機能を
//  活用することを目的としています。
//
const std = @import("std");
const Builder = std.Build;
const Step = std.Build.Step;
const fs = std.fs;

pub fn build(b: *Builder) !void {
    //==============================================================================
    // 1. ビルドオプションと基本設定
    //==============================================================================
    const target = b.standardTargetOptions(.{
        // Makefile.coreの 'arm-none-eabi' に基づくターゲット
        .default_target = .{
            .cpu_arch = .arm,
            .os_tag = .freestanding,
            .abi = .eabi,
            .cpu_model = .{ .explicit = &std.Target.arm.cpu.mpcore },
        },
    });

    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug,
    });

    // const srclang = b.option(enum { c, cxx, zig }, "srclang", "Application source language") orelse .c;
    const omit_tecs = b.option(bool, "omit_tecs", "Omit TECS features") orelse false;
    const enable_trace = b.option(bool, "enable_trace", "Enable trace logging") orelse false;

    //==============================================================================
    // 2. パスと設定値の定義 (Makefile群から抽出)
    //==============================================================================
    const srcdir = "..";
    const target_name = "ct11mpcore_gcc";
    const coredir = b.path(b.fmt("{s}/arch/arm_gcc/common", .{srcdir}));
    const targetdir = b.path(b.fmt("{s}/target/{s}", .{ srcdir, target_name }));
    const tecsgendir = "gen";

    // Makefile.target からの設定
    const target_config = struct {
        const ldscript = "ct11mpcore.ld";
        const text_start_address = "0x01000000";
        const data_start_address = "0x01800000";
        const c_defs = &[_]Builder.Define{.{ .name = "__TARGET_ARCH_ARM", .value = "6" }};
        const c_flags = &[_][]const u8{ "-mlittle-endian", "-mcpu=mpcore" };
    };

    // Makefile.core からの設定
    const core_config = struct {
        const start_objs = &[_][]const u8{ "core_support.o", "start.o" };
        const core_sym_def = "core_sym.def";
        const core_offset_trb = "core_offset.trb";
    };

    // Makefile.tecsgen からのファイルリスト
    const tecs_config = struct {
        // tecsgenの依存ファイル
        const tecsgen_imports = &[_][]const u8{
            "../sample/sample1.cdl",                  "../tecs_kernel/kernel.cdl",                       "../syssvc/tSerialPort.cdl",
            "../syssvc/tSerialAdapter.cdl",           "../syssvc/tSysLog.cdl",                           "../syssvc/tSysLogAdapter.cdl",
            "../syssvc/tLogTask.cdl",                 "../syssvc/tBanner.cdl",                           "../target/ct11mpcore_gcc/target.cdl",
            "../syssvc/tPutLogSIOPort.cdl",           "../target/ct11mpcore_gcc/tSIOPortCT11MPCore.cdl", "../arch/arm_gcc/common/tUartPL011.cdl",
            "./gen/tmp_NotifierPlugin_post_code.cdl", "../tecs_kernel/tecs_kernel.h",                    "../syssvc/serial.h",
            "../syssvc/syslog.h",                     "../target/ct11mpcore_gcc/ct11mpcore.h",           "../arch/arm_gcc/common/uart_pl011.h",
        };
        // tecsgenが生成するCソース
        const tecsgen_generated_c_sources = &[_][]const u8{
            "tTask_tecsgen.c",           "tSemaphore_tecsgen.c",         "tInterruptRequest_tecsgen.c",
            "tISR_tecsgen.c",            "tInitializeRoutine_tecsgen.c", "tTerminateRoutine_tecsgen.c",
            "tSerialPortMain_tecsgen.c", "tSerialAdapter_tecsgen.c",     "tSysLog_tecsgen.c",
            "tSysLogAdapter_tecsgen.c",  "tLogTaskMain_tecsgen.c",       "tBannerMain_tecsgen.c",
            "tPutLogSIOPort_tecsgen.c",  "tUartPL011_tecsgen.c",         "tSIOPortCT11MPCoreMain_tecsgen.c",
        };
        // ユーザーが記述したCソース (tecsgen関連)
        const tecs_user_c_sources = &[_][]const u8{
            "tTask.c",           "tISR.c",           "tInitializeRoutine.c", "tTerminateRoutine.c",
            "tSerialPortMain.c", "tSerialAdapter.c", "tSysLog.c",            "tSysLogAdapter.c",
            "tLogTaskMain.c",    "tBannerMain.c",    "tPutLogSIOPort.c",     "tUartPL011.c",
        };
    };

    //==============================================================================
    // 3. TECSコード生成ステップ (`tecs` ターゲット)
    //==============================================================================
    const tecs_step = b.step("tecs", "Generate TECS source files");
    var generated_tecs_sources = std.ArrayList(Builder.GeneratedFile).init(b.allocator);
    var run_cfg_cmd_dep: ?*Step = null;

    if (!omit_tecs) {
        const tecsgen_rb = b.fmt("{s}/tecsgen/tecsgen.rb", .{srcdir});
        const appl_cdl = b.fmt("{s}/sample/sample1.cdl", .{srcdir});

        // tecsgenコマンドの定義
        const tecsgen_cmd = b.addSystemCommand(&.{
            "ruby",  tecsgen_rb,            appl_cdl, "-g", tecsgendir,
            // Cプリプロセッサの引数をtecsgenに渡すための設定
            // INCLUDESをコマンドラインで渡すのは複雑なため、CDL内のimportで解決されることを期待
            "--cpp", "zig cc -E -DTECSGEN",
        });

        // tecsgenが依存する全ファイルへの依存関係を設定
        // for (tecs_config.tecsgen_imports) |import_file| {
        //     // workaround for tmp_NotifierPlugin_post_code.cdl which may not exist initially
        //     if (fs.path.basename(import_file).len > 0) {
        //         tecsgen_cmd.step.dependOn(b.addInstallFileWithDir(.{ .path = import_file }, .keep_dir, "").step);
        //     }
        // }

        // tecsgenの生成物を出力として宣言
        for (tecs_config.tecsgen_generated_c_sources) |src| {
            try generated_tecs_sources.append(.{ .step = tecs_step, .path = b.pathJoin(&.{ tecsgendir, src }) });
        }

        // genTecsCfg.rb を実行するコマンド
        const gen_tecs_cfg_cmd = b.addSystemCommand(&.{
            "ruby",
            b.fmt("{s}/cfg/genTecsCfg.rb", .{srcdir}),
            "--api-table",
            b.fmt("{s}/kernel/kernel_api.def", .{srcdir}),
            b.fmt("{s}/tecsgen.cfg", .{tecsgendir}),
        });
        gen_tecs_cfg_cmd.step.dependOn(&tecsgen_cmd.step);
        tecs_step.dependOn(&gen_tecs_cfg_cmd.step);
        run_cfg_cmd_dep = &gen_tecs_cfg_cmd.step;
    }

    //==============================================================================
    // 4. コンフィギュレータ(cfg.rb)実行ステップ
    //==============================================================================
    const cfg_rb = b.fmt("{s}/cfg/cfg.rb", .{srcdir});
    const cfg1_out_c = "kernel_cfg.c";
    const run_cfg_cmd = b.addSystemCommand(&.{
        "ruby",
        cfg_rb,
        "--kernel",
        "asp",
        "--api-table",
        b.fmt("{s}/kernel/kernel_api.def", .{srcdir}),
        "--symval-table",
        b.fmt("{s}/kernel/kernel_sym.def", .{srcdir}),
        "--symval-table",
        b.fmt("{s}/{s}", .{ coredir, core_config.core_sym_def }),
        "-c",
        cfg1_out_c,
        b.fmt("{s}/sample/sample1.cfg", .{srcdir}),
    });

    if (run_cfg_cmd_dep) |dep| {
        run_cfg_cmd.step.dependOn(dep);
    }
    const kernel_cfg_source = .{ .file = run_cfg_cmd.addOutputFileArg(cfg1_out_c) };

    //==============================================================================
    // 5. カーネルライブラリのビルド (`libkernel.a`)
    //==============================================================================
    const kernel_lib = b.addStaticLibrary(.{
        .name = "kernel",
        .root_source_file = b.path(b.fmt("{s}/kernel/c_api.zig", .{srcdir})),
        .target = target,
        .optimize = optimize,
    });
    kernel_lib.defineCMacro("TARGET", b.fmt("\"{s}\"", .{target_name}));
    kernel_lib.defineCMacro("SRCDIR", b.fmt("\"{s}\"", .{srcdir}));

    //==============================================================================
    // 6. メイン実行可能ファイルの定義 (`asp`)
    //==============================================================================
    const exe = b.addExecutable(.{
        .name = "asp",
        .target = target,
        .optimize = optimize,
    });
    exe.nostdlib = true; // Makefile.core: LDFLAGS := -nostdlib $(LDFLAGS)
    exe.setLinkerScript(.{ .path = b.path(b.fmt("{s}/{s}", .{ targetdir, target_config.ldscript })) });

    // C/C++の共通フラグとインクルードパスを設定
    const c_flags = &[_][]const u8{ "-Wall", "-g", "-ffunction-sections", "-fdata-sections" };
    exe.addCSourceFiles(.{ .flags = c_flags });
    exe.addCSourceFiles(.{ .flags = target_config.c_flags });

    // インクルードパス (Makefile, Makefile.target, Makefile.core)
    exe.addIncludePath(.{ .path = "." });
    exe.addIncludePath(.{ .path = tecsgendir });
    exe.addIncludePath(.{ .path = b.path(b.fmt("{s}/include", .{srcdir})) });
    exe.addIncludePath(.{ .path = srcdir });
    exe.addIncludePath(.{ .path = b.path(b.fmt("{s}/sample", .{srcdir})) });
    exe.addIncludePath(.{ .path = b.path(b.fmt("{s}/library", .{srcdir})) });
    exe.addIncludePath(.{ .path = b.path(b.fmt("{s}/tecs_kernel", .{srcdir})) });
    exe.addIncludePath(.{ .path = targetdir }); // from Makefile.target
    exe.addIncludePath(.{ .path = coredir }); // from Makefile.core
    exe.addIncludePath(.{ .path = b.path(b.fmt("{s}/arch/gcc", .{srcdir})) }); // from Makefile.core

    // Cの定義を設定
    exe.addDefine("TOPPERS_USE_QEMU", "1");
    for (target_config.c_defs) |def| {
        exe.addDefine(def.name, def.value);
    }
    if (omit_tecs) {
        exe.addDefine("TOPPERS_OMIT_TECS", "1");
    }
    if (enable_trace) {
        exe.addDefine("TOPPERS_ENABLE_TRACE", "1");
    }

    // ソースファイルを追加
    exe.addCSourceFiles(.{
        .files = &.{
            // from sample1
            "../sample/sample1.c",
            "../library/log_output.c",
            "../library/vasyslog.c",
            "../library/t_perror.c",
            "../library/strerror.c",
            // from Makefile.core start_objs
            "../arch/arm_gcc/common/core_support.S",
            "../arch/arm_gcc/common/start.S",
        },
    });
    // TECSのユーザー記述ソース
    for (tecs_config.tecs_user_c_sources) |src| {
        // vpathを模倣して複数のディレクトリを探索
        const syssvc_path = b.path(b.fmt("{s}/syssvc/{s}", .{ srcdir, src }));
        // const kernel_path = b.path(b.fmt("{s}/tecs_kernel/{s}", .{ srcdir, src }));
        // const core_path = b.path(b.fmt("{s}/{s}", .{ coredir, src }));
        // TODO: ファイル存在チェックをしてから追加するのが望ましい
        exe.addCSourceFile(.{ .file = syssvc_path, .flags = &.{"-Wno-implicit-function-declaration"} });
    }

    // TECSの自動生成ソース
    exe.addCSourceFiles(.{ .files = generated_tecs_sources.items, .flags = &.{"-Wno-implicit-function-declaration"} });
    // コンフィギュレータ生成ソース
    exe.addCSourceFile(kernel_cfg_source);

    // ライブラリとリンカフラグをリンク
    exe.linkLibrary(kernel_lib);
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("gcc"); // from Makefile.core
    exe.addLdFlags(&.{"-Wl,--gc-sections"});
    exe.addLdFlags(target_config.c_flags);
    exe.addLdFlags(&.{
        b.fmt("-Wl,-Ttext,{s}", .{target_config.text_start_address}),
        b.fmt("-Wl,-Tdata,{s}", .{target_config.data_start_address}),
    });

    //==============================================================================
    // 7. ポストビルド＆チェックステップ (`check` ターゲット)
    //==============================================================================
    const check_step = b.step("check", "Check configuration of the built kernel");
    const check_config_rb = b.path(b.fmt("{s}/cfg/checkConfig.rb", .{srcdir}));
    const syms_file = "asp.syms";
    const srec_file = "asp.srec";

    const gen_syms_cmd = b.addSystemCommand(&.{ "nm", "-n", exe.getOutputExe().getPath(), ">", syms_file });
    const gen_srec_cmd = b.addSystemCommand(&.{ "objcopy", "-O", "srec", "-S", exe.getOutputExe().getPath(), srec_file });
    gen_syms_cmd.step.dependOn(b.getInstallStep());
    gen_srec_cmd.step.dependOn(b.getInstallStep());

    const run_check_cmd = b.addSystemCommand(&.{
        "ruby",
        check_config_rb,
        "check_defs", // これはcfg.rbから生成されるオブジェクトから抽出する必要がある
        "-T",
        b.path(b.fmt("{s}/{s}", .{ coredir, core_config.core_offset_trb })),
        "--rom-symbol",
        syms_file,
        "--rom-image",
        srec_file,
    });
    run_check_cmd.step.dependOn(&gen_syms_cmd.step);
    run_check_cmd.step.dependOn(&gen_srec_cmd.step);

    check_step.dependOn(&run_check_cmd.step);

    //==============================================================================
    // 8. トップレベルの合成ステップ (`all`, `run`, `clean`)
    //==============================================================================
    b.installArtifact(exe);

    const all_step = b.step("all", "Build all and run checks (default)");
    all_step.dependOn(&check_step.step);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the application (requires QEMU or hardware)");
    run_step.dependOn(&run_cmd.step);

    const clean_step = b.step("clean", "Remove generated files");
    const clean_cmd = b.addSystemCommand(&.{
        "rm",       "-rf",      "zig-out",      "zig-cache", tecsgendir,
        "asp.syms", "asp.srec", "kernel_cfg.c",
    });
    clean_step.dependOn(&clean_cmd.step);
}
