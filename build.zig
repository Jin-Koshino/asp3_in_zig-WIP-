const std = @import("std");

pub fn build(b: *std.Build) !void {
    // const TARGET: []const u8= "ct11mpcore";
    // const SRCLANG: []const u8 = "zig";
    // const SRCDIR: []const u8 = ".";
    // const OBJEXT: []const u8 = "";
    // const KERNEL_LIB: []const u8 = "";
    // const OMIT_TECS: []const u8 = "";
    // const TECSDIR: []const u8 = SRCDIR ++ "/tecsgen";
    // const ENABLE_TRACE: []const u8 = "";
    // const DEVTOOLDIR: []const u8 = "";
    // const CFG: []const u8 = "ruby" ++ SRCDIR ++ "/cfg/cfg.rb";
    // const TECSGEN: []const u8 = "ruby" ++ TECSDIR ++ "/tecsgen.rb";
    // const OBJNAME: []const u8 = "asp";
    // const OBJFILE = if (OBJEXT.len != 0) {OBJNAME ++ "." ++ OBJEXT;} else {OBJNAME;};
    // const CFG1_OUT = if (OBJEXT.len != 0) {"cfg1_out." ++ OBJEXT;} else {"cfg1_out";};
    // const OBJDIR = "objs";
    // const DEPDiR = "objs";
    // const TARGETDIR = SRCDIR ++ "/target/" ++ TARGET;

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .arm,
        .os_tag = .freestanding,
        .abi = .eabi,
    });

    const optimize = b.standardOptimizeOption(.{});

    // const tecsgen_step = b.addSystemCommand(&.{ "ruby", "tecsgen/tecsgen.rb", "sample/sample1.cdl", "-R", "-I.", "-Iinclude", "-Itarget/ct11mpcore_gcc", "-Iarch/arm_gcc/common", "-Iarch/gcc", "-I..", "-Isample", "-I./gen", "-Itecs_kernel", "--cpp \"arm-none-eabi-gcc  -D__TARGET_ARCH_ARM=6 -DTOPPERS_USE_QEMU -I. -Iinclude  -Itarget/ct11mpcore_gcc -Iarch/arm_gcc/common -Iarch/gcc -I.. -Isample -I./gen -Itecs_kernel -D TECSGEN -E\"", "-g", "./gen " });

    // オブジェクトファイルを生成
    const obj = b.addObject(.{
        .name = "sample1_cfg",
        .root_source_file = .{ .path = "sample/sample1_cfg.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });

    // obj.step.dependOn(&tecsgen_step.step);

    // 各ディレクトリのroot.zigをモジュールとして登録
    // kernelディレクトリのroot.zigをモジュールとして登録
    const kernel_mod = b.createModule(.{
        .root_source_file = .{ .path = "kernel/root.zig" },
    });

    // libraryディレクトリのroot.zigをモジュールとして登録
    const library_mod = b.createModule(.{
        .root_source_file = .{ .path = "library/root.zig" },
    });

    // archディレクトリのroot.zigをモジュールとして登録
    const arch_mod = b.createModule(.{
        .root_source_file = .{ .path = "arch/root.zig" },
    });

    // OBJ-ARMディレクトリのtecsgen_cfg.zigをモジュールとして登録
    const objarm_mod = b.createModule(.{
        .root_source_file = .{ .path = "OBJ-ARM/gen/tecsgen_cfg.zig" },
    });

    // includeディレクトリのroot.zigをモジュールとして登録
    const include_mod = b.createModule(.{
        .root_source_file = .{ .path = "include/root.zig" },
    });

    // targetディレクトリのroot.zigをモジュールとして登録
    const target_mod = b.createModule(.{
        .root_source_file = .{ .path = "target/root.zig" },
    });

    obj.root_module.addImport("kernel", kernel_mod);
    obj.root_module.addImport("objarm", objarm_mod);

    // kernel, library, arch, OBJ-ARM, include, target
    kernel_mod.addImport("kernel", kernel_mod);
    kernel_mod.addImport("library", library_mod);
    kernel_mod.addImport("include", include_mod);
    kernel_mod.addImport("target", target_mod);
    library_mod.addImport("include", include_mod);
    include_mod.addImport("arch", arch_mod);
    include_mod.addImport("include", include_mod);
    include_mod.addImport("target", target_mod);
    target_mod.addImport("kernel", kernel_mod);
    target_mod.addImport("arch", arch_mod);
    target_mod.addImport("objarm", objarm_mod);
    target_mod.addImport("include", include_mod);
    target_mod.addImport("target", target_mod);
    arch_mod.addImport("kernel", kernel_mod);
    arch_mod.addImport("arch", arch_mod);
    arch_mod.addImport("include", include_mod);
    objarm_mod.addImport("kernel", kernel_mod);
    objarm_mod.addImport("target", target_mod);

    // マクロ定義の追加
    obj.defineCMacro("__TARGET_ARCH_ARM", "6");
    obj.defineCMacro("TOPPERS_USE_QEMU", null);

    // インクルードディレクトリの追加
    const include_dirs = [_][]const u8{
        "",
        "include",
        "target/ct11mpcore_gcc",
        "arch/arm_gcc/common",
        "arch/gcc",
        "sample",
        "OBJ-ARM",
        "OBJ-ARM/gen",
        "tecs_kernel",
        "syssvc",
    };
    for (include_dirs) |path_h| {
        objarm_mod.addIncludePath(b.path(path_h));
        obj.addIncludePath(b.path(path_h));
    }

    // objsディレクトリにsample1_cfg.oをコピー
    const emit_obj = b.addInstallFileWithDir(obj.getEmittedBin(), .{ .custom = "../OBJ-ARM/objs" }, "sample1_cfg.o");
    // zig buildの一部としてinstall_stepを実行
    b.getInstallStep().dependOn(&emit_obj.step);

    // カーネルライブラリファイルの生成
    const lib = b.addStaticLibrary(.{
        .name = "kernel",
        .root_source_file = .{ .path = "kernel/c_api.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });

    // lib.step.dependOn(&emit_obj.step);

    for (include_dirs) |path_h| {
        lib.addIncludePath(b.path(path_h));
        library_mod.addIncludePath(b.path(path_h));
    }

    lib.root_module.addImport("kernel", kernel_mod);
    lib.root_module.addImport("library", library_mod);

    lib.defineCMacro("__TARGET_ARCH_ARM", "6");
    lib.defineCMacro("TOPPERS_USE_QEMU", null);

    const emit_lib = b.addInstallFileWithDir(lib.getEmittedBin(), .{ .custom = "../OBJ-ARM/objs" }, "libkernel.a");

    b.getInstallStep().dependOn(&emit_lib.step);
}
