const std = @import("std");

//  オプションの定義

//  -T <target>			ターゲット名（必須）
//  -a <appldirs>		アプリケーションのディレクトリ名（複数指定可．デ
// 						フォルトはsampleディレクトリ）
//  -A <applname>		アプリケーションプログラム名（デフォルトはsample1）
//  -t					メインのオブジェクトファイルをリンク対象に含めない
//  -c <zigcfg>			システムコンフィギュレーション記述のファイル（.zig
// 						ファイル名）名
//  -C <cdlflle>			コンポーネント記述ファイル（.cdlファイル）名
//  -U <applobjs>		アプリケーションの追加のオブジェクトファイル
// 						（.oファイル名で指定．複数指定可）
//  -S <syssvcobjs>		システムサービスのオブジェクトファイル
// 						（.oファイル名で指定．複数指定可）
//  -B <bannerobj>		バナー表示のオブジェクトファイル（.oファイル名で指定）
//  -L <kernel_lib>		カーネルライブラリ（libkernel.a）のディレクトリ名
// 						（省略した場合，カーネルライブラリもmakeする）
//  -M <mode>			コンパイルモード（Safe，Fast，Smallのいずれか）
//  -n <bind_cfg>		カーネルとコンフィギュレーションデータを一体で
// 						コンパイルする場合のシステムコンフィギュレーショ
// 						ン記述のファイル（.zig）
//  -D <srcdir>			カーネルソースの置かれているディレクトリ
//  -l <srclang>			プログラミング言語（c，c++，zigのいずれか）
//  -m <tempmakefile>	Makefileのテンプレートのファイル名の指定（デフォル
// 						トはsampleディレクトリのMakefile）
//  -d <objdir>			中間オブジェクトファイルと依存関係ファイルを置く
// 						ディレクトリ名（デフォルトはobjs）
//  -w					TECSを使用しない
//  -W <tecsdir>			TECS関係ファイルのディレクトリ名（デフォルトはソー
// 						スファイルのディレクトリの下のtecsgen）
//  -r					トレースログ記録のサンプルコードを使用するかどうか
// 						の指定
//  -V <devtooldir>		開発ツール（コンパイラ等）の置かれているディレクトリ
//  -R <ruby>			rubyのパス名（明示的に指定する場合）
//  -g <cfg>				コンフィギュレータ（cfg）のパス名
//  -G <tecsgen>			TECSジェネレータ（tecsgen）のパス名
//  -o <options>			コンパイルオプション（COPTSに追加）
//  -O <options>			シンボル定義オプション（CDEFSに追加）
//  -k <options>			リンカオプション（LDFLAGSに追加）
//  -b <options>			リンカオプション（LIBSに追加）

//  使用例(1)

//  % ../configure.rb -T ct11mpcore_gcc -O "-DTOPPERS_USE_QEMU" \
// 					-A perf1 -a ../test -S "test_svc.o histogram.o"

//  使用例(2)

//  % ../configure.rb -T macosx_gcc -L .
// 	アプリケーションプログラムは，sample1になる．

//  使用例(3)

//  % ../configure.rb -T ct11mpcore_gcc -O "-DTOPPERS_USE_QEMU" -A tSample2 -t
// 	アプリケーションプログラムは，TECS版のサンプルプログラムになる．

//  使用例(4)

//  % ../configure.rb -T ct11mpcore_gcc PRC_NUM=4
// 	PRC_NUMを4に定義する．

// const DEFINE_CONFIGURATION = struct {
//     const flags = struct {};
//     TARGET: []const u8,
//     SRCLANG: []const u8,
//     LIBS: []const u8,
//     USE_CXX: []const u8,
//     CXXLIBS: []const u8,
//     CXXRTS: []const u8,
//     USE_ZIG: []const u8,
//     SRCDIR: []const u8,
//     OBJEXT: []const u8,
//     KERNEL_LIB: []const u8,
//     BIND_CFG: []const u8,
//     OMIT_TECS: []const u8,
//     TECSDIR: []const u8,
//     ENABLE_TRACE: []const u8,
//     DEVTOOLDIR: []const u8,
//     CFG: []const u8,
//     TECSGEN: []const u8,
//     OBJNAME: []const u8,
//     OBJFILE: []const u8,
//     CFG1_OUT: []const u8,
//     OBJDIR: []const u8,
//     DEPDIR: []const u8,
//     TARGETDIR: []const u8,
//     TECSGENDIR: []const u8,
//     TECSGEN_TIMESTAMP: []const u8,
//     INIT_TECS_COBJ: []const u8,
//     GEN_DIR: []const u8,
//     COPTS: []const u8,
//     CDEFS: []const u8,
//     INCLUDES: []const u8,
//     LDFLAGS: []const u8,
//     OBJ_LDFLAGS: []const u8,
//     CFLAGS: []const u8,
//     ZIGOPTS: []const u8,
//     ZIGFLAGS: []const u8,
//     APPLNAME: []const u8,
//     APPLDIRS: []const u8,
//     APPL_CDL: []const u8,
//     APPL_DIRS: []const u8,
//     APPL_ASMOBJS: []const u8,
//     APPL_ZIGOBJS: []const u8,
//     APPL_COBJS: []const u8,
//     APPL_CXXOBJS: []const u8,
//     APPL_CFLAGS: []const u8,
//     SYSSVC_DIRS: []const u8,
//     SYSSVC_ASMOBJS: []const u8,
//     SYSSVC_COBJS: []const u8,
//     SYSSVC_CFLAGS: []const u8,
//     CFG_KERNEL: []const u8,
//     CFG_TABS: []const u8,
//     CFGOBJ: []const u8,
//     APPL_OBJS: []const u8,
//     SYSSVC_OBJS: []const u8,
//     ALL_OBJS: []const u8,
//     ALL_LIBS: []const u8,
//     LIBS_DEP: []const u8,
//     REALCLEAN_FILES: []const u8,
//     TARGET_CHECK_TRB: []const u8,
//     TECS_CPP: []const u8,
//     TECSGEN_SRCS: []const u8,
//     TECS_HEADERS: []const u8,
//     ZIGCFG: []const u8,
//     BANNEROBJ: []const u8,
//     MODE: []const u8,
//     BUILDDIR: []const u8,
//     APPLOBJS: []const u8,
//     SYSSVCOBJS: []const u8,
//     TECS_COBJS: []const u8,
//     START_OBJS: []const u8,
//     END_OBJS: []const u8,
//     HIDDEN_OBJS: []const u8,
//     TEXT_START_ADDRESS: []const u8,
//     DATA_START_ADDRESS: []const u8,
//     LDSCRIPT: []const u8,
//     TOOL: []const u8,
//     GCC_TARGET: []const u8,
//     GCC_TARGET_PREFIX: []const u8,
//     CC: []const u8,
//     CXX: []const u8,
//     AS: []const u8,
//     LD: []const u8,
//     AR: []const u8,
//     NM: []const u8,
//     RANLIB: []const u8,
//     OBJCOPY: []const u8,
//     OBJDUMP: []const u8,
//     LINK: []const u8,

//     // 初期メンバ変数から導出できる定義をまとめて設定
//     fn define(self: *@This()) void {
//         self.TARGET = "ct11mpcore_gcc";
//     }

//     // このstruct内に，memberで指定した名前のメンバ変数が存在するか返す
//     // 値が代入されていない場合はfalse
//     fn ifdef(self: *@This(), member: []const u8) bool {
//         return @hasDecl(self, member);
//     }
// };

pub fn build(b: *std.Build) !void {
    // const _opt_target = b.option([]const u8, "T", "target name (mandatory)");
    // const _opt_appldirs = b.option([]const u8, "a", "application directories") orelse "sample";
    // const _opt_applname = b.option([]const u8, "A", "application program name") orelse "sample1";
    // const _opt_no_main = b.option(bool, "t", "TECS is used for application development") orelse false;
    // const _opt_zigcfg = b.option([]const u8, "c", "system configuration description file") orelse "";
    // const _opt_cdlfile = b.option([]const u8, "C", "component description file") orelse "";
    // const _opt_applobjs = b.option([]const u8, "U", "additional application object files") orelse "";
    // const _opt_syssvcobjs = b.option([]const u8, "S", "system service object files") orelse "";
    // const _opt_bannerobj = b.option([]const u8, "B", "banner display object file") orelse "";
    // const _opt_kernel_lib = b.option([]const u8, "L", "directory of built kernel library") orelse "";
    // const _opt_mode = b.option([]const u8, "M", "compile mode (Safe, Fast, or Small)") orelse "Release";
    // const _opt_bind_cfg = b.option([]const u8, "n", "system configuration description file when compiled with kernel in one") orelse "";
    // const _opt_srcdir = b.option([]const u8, "D", "path of source code directory") orelse "..";
    // const _opt_srclang = b.option([]const u8, "l", "programming language (C or C++)") orelse "zig";
    // const _opt_makefile = b.option([]const u8, "m", "template file of Makefile") orelse "";
    // const _opt_objdir = b.option([]const u8, "d", "relocatable object file directory") orelse "objs";
    // const _opt_omit_tecs = b.option(bool, "w", "TECS is not used at all") orelse false;
    // const _opt_tecsdir = b.option([]const u8, "W", "path of TECS file directory") orelse _opt_srcdir ++ "/tecsgen";
    // const _opt_enable_trace = b.option(bool, "r", "use the sample code for trace log") orelse false;
    // const _opt_devtooldir = b.option([]const u8, "V", "development tools directory") orelse "";
    // const _opt_ruby_path = b.option([]const u8, "R", "path of ruby command") orelse "ruby";
    // const _opt_cfg_path = b.option([]const u8, "g", "path of configurator") orelse "";
    // const _opt_tecsgen_path = b.option([]const u8, "G", "path of TECS generator") orelse "";
    // const _opt_copts = b.option([]const u8, "o", "compiler options") orelse "";
    // const _opt_cdefs = b.option([]const u8, "O", "symbol definition options") orelse "";
    // const _opt_ldflags = b.option([]const u8, "k", "linker options") orelse "";
    // const _opt_libs = b.option([]const u8, "b", "linker options for linking libraries") orelse "";

    // // Derived constants used later in the build script (names follow Makefile)
    // if(_opt_target == null){
    //     std.debug.print("-DT option is mandatory");
    // }
    // const TARGET = _opt_target;
    // const SRCLANG = _opt_srclang;
    // const SRCDIR = _opt_srcdir;
    // const OBJEXT: []const u8 = "";
    // const KERNEL_LIB = _opt_kernel_lib;
    // const BIND_CFG = _opt_bind_cfg;
    // const OMIT_TECS = if (_opt_omit_tecs) "1" else "";
    // const TECSDIR = _opt_tecsdir;
    // const ENABLE_TRACE = if (_opt_enable_trace) "1" else "";
    // const DEVTOOLDIR = _opt_devtooldir;
    // const CFG = _opt_cfg;
    // const TECSGEN = _opt_tecsgen;
    // const OBJNAME: []const u8 = "asp";
    // const OBJDIR = _opt_objdir;
    // const DEPDIR = OBJDIR;
    // const TARGETDIR = SRCDIR ++ "/target/" ++ TARGET;

    // // Collect option/derived strings into a single array to mark them as used
    // const _all_opts = [_][]const u8{
    //     TARGET,
    //     SRCLANG,
    //     SRCDIR,
    //     OBJEXT,
    //     OMIT_TECS,
    //     KERNEL_LIB,
    //     BIND_CFG,
    //     // OMIT_TECS is also added above; keep _opt flag expression for completeness
    //     if (_opt_omit_tecs) "1" else "",
    //     TECSDIR,
    //     ENABLE_TRACE,
    //     DEVTOOLDIR,
    //     CFG,
    //     TECSGEN,
    //     OBJNAME,
    //     OBJDIR,
    //     DEPDIR,
    //     TARGETDIR,
    //     _opt_appldirs,
    //     _opt_applname,
    //     if (_opt_no_main) "1" else "",
    //     _opt_zigcfg,
    //     _opt_cdlfile,
    //     _opt_applobjs,
    //     _opt_syssvcobjs,
    //     _opt_bannerobj,
    //     _opt_mode,
    //     _opt_makefile,
    //     _opt_objdir,
    //     _opt_tecsdir,
    //     _opt_devtooldir,
    //     _opt_ruby,
    //     _opt_copts,
    //     _opt_cdefs,
    //     _opt_ldflags,
    //     _opt_libs,
    // };
    // _ = _all_opts;

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .arm,
        .os_tag = .freestanding,
        .abi = .eabi,
    });
    const optimize = b.standardOptimizeOption(.{});

    // //
    // // ターゲット依存の定義のインクルード
    // //
    // // include $(TARGETDIR)/Makefile.target
    // const target_dep = undefined;
    // _ = target_dep;

    // //
    // //  TECS生成ファイルのディレクトリの定義
    // //
    // // TECSGENDIR = ./gen
    // // ifndef OMIT_TECS
    // // 	   TECSGEN_TIMESTAMP = $(TECSGENDIR)/tecsgen.timestamp
    // // 	   INIT_TECS_COBJ = init_tecs.o
    // // endif
    // const TECSGENDIR = "./gen";
    // _ = TECSGENDIR;

    // const configure = b.addSystemCommand(&.{ "../configure.rb", "-T", "ct11mpcore_gcc", "-O", "-DTOPPERS_USE_QEMU" });
    // configure.setCwd(b.path("OBJ-ARM"));
    // const tecsgen = b.addSystemCommand(&.{ "ruby", SRCDIR ++ "/tecsgen/tecsgen.rb", "sample/sample1.cdl", "-R", "-I.", "-Iinclude", "-Itarget/ct11mpcore_gcc", "-Iarch/arm_gcc/common", "-Iarch/gcc", "-I..", "-Isample", "-I./gen", "-Itecs_kernel", "--cpp", "arm-none-eabi-gcc", "-D__TARGET_ARCH_ARM=6", "-DTOPPERS_USE_QEMU", "-I.", "-Iinclude", "-Itarget/ct11mpcore_gcc", "-Iarch/arm_gcc/common", "-Iarch/gcc", "-I..", "-Isample", "-I./gen", "-Itecs_kernel -D TECSGEN -E", "-g", "./gen " });
    // tecsgen.setCwd(b.path("OBJ-ARM"));
    // tecsgen.step.dependOn(&configure.step);

    // オブジェクトファイルを生成
    const obj = b.addObject(.{
        .name = "sample1_cfg",
        .root_source_file = .{ .path = "../sample/sample1_cfg.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });

    // obj.step.dependOn(&tecsgen.step);

    // 各ディレクトリのroot.zigをモジュールとして登録
    // kernelディレクトリのroot.zigをモジュールとして登録
    const kernel_mod = b.createModule(.{
        .root_source_file = .{ .path = "../kernel/root.zig" },
    });

    // libraryディレクトリのroot.zigをモジュールとして登録
    const library_mod = b.createModule(.{
        .root_source_file = .{ .path = "../library/root.zig" },
    });

    // archディレクトリのroot.zigをモジュールとして登録
    const arch_mod = b.createModule(.{
        .root_source_file = .{ .path = "../arch/root.zig" },
    });

    // OBJ-ARMディレクトリのtecsgen_cfg.zigをモジュールとして登録
    const objarm_mod = b.createModule(.{
        .root_source_file = .{ .path = "../OBJ-ARM/gen/tecsgen_cfg.zig" },
    });

    // includeディレクトリのroot.zigをモジュールとして登録
    const include_mod = b.createModule(.{
        .root_source_file = .{ .path = "../include/root.zig" },
    });

    // targetディレクトリのroot.zigをモジュールとして登録
    const target_mod = b.createModule(.{
        .root_source_file = .{ .path = "../target/root.zig" },
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
        "..",
        "../include",
        "../target/ct11mpcore_gcc",
        "../arch/arm_gcc/common",
        "../arch/gcc",
        "../sample",
        "../OBJ-ARM",
        "../OBJ-ARM/gen",
        "../tecs_kernel",
        "../syssvc",
    };
    for (include_dirs) |path_h| {
        objarm_mod.addIncludePath(b.path(path_h));
        obj.addIncludePath(b.path(path_h));
    }

    // objsディレクトリにsample1_cfg.oをコピー
    const emit_obj = b.addInstallFileWithDir(obj.getEmittedBin(), .{ .custom = "OBJ-ARM/objs" }, "sample1_cfg.o");
    // zig buildの一部としてinstall_stepを実行
    b.getInstallStep().dependOn(&emit_obj.step);

    // カーネルライブラリファイルの生成
    const lib = b.addStaticLibrary(.{
        .name = "kernel",
        .root_source_file = .{ .path = "../kernel/c_api.zig" },
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

    const emit_lib = b.addInstallFileWithDir(lib.getEmittedBin(), .{ .custom = "OBJ-ARM" }, "libkernel.a");

    b.getInstallStep().dependOn(&emit_lib.step);
}
