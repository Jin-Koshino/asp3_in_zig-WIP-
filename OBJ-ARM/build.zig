const std = @import("std");

const configuration_variables = struct {
    TARGET: []const u8 = "ct11mpcore",
    SRCLANG: []const u8 = "",
    LIBS: []const u8 = "",
    USE_CXX: []const u8 = "",
    CXXLIBS: []const u8 = "",
    CXXRTS: []const u8 = "",
    USE_ZIG: []const u8 = "",
    SRCDIR: []const u8 = "",
    OBJEXT: []const u8 = "",
    KERNEL_LIB: []const u8 = "",
    BIND_CFG: []const u8 = "",
    OMIT_TECS: []const u8 = "",
    TECSDIR: []const u8 = "",
    ENABLE_TRACE: []const u8 = "",
    DEVTOOLDIR: []const u8 = "",
    CFG: []const u8 = "",
    TECSGEN: []const u8 = "",
    OBJNAME: []const u8 = "",
    OBJFILE: []const u8 = "",
    CFG1_OUT: []const u8 = "",
    OBJDIR: []const u8 = "",
    DEPDIR: []const u8 = "",
    TARGETDIR: []const u8 = "",
    TECSGENDIR: []const u8 = "",
    TECSGEN_TIMESTAMP: []const u8 = "",
    INIT_TECS_COBJ: []const u8 = "",
    GEN_DIR: []const u8 = "",
    COPTS: []const u8 = "",
    CDEFS: []const u8 = "",
    INCLUDES: []const u8 = "",
    LDFLAGS: []const u8 = "",
    OBJ_LDFLAGS: []const u8 = "",
    CFLAGS: []const u8 = "",
    ZIGOPTS: []const u8 = "",
    ZIGFLAGS: []const u8 = "",
    APPLNAME: []const u8 = "",
    APPLDIRS: []const u8 = "",
    APPL_CDL: []const u8 = "",
    APPL_DIRS: []const u8 = "",
    APPL_ASMOBJS: []const u8 = "",
    APPL_ZIGOBJS: []const u8 = "",
    APPL_COBJS: []const u8 = "",
    APPL_CXXOBJS: []const u8 = "",
    APPL_CFLAGS: []const u8 = "",
    SYSSVC_DIRS: []const u8 = "",
    SYSSVC_ASMOBJS: []const u8 = "",
    SYSSVC_COBJS: []const u8 = "",
    SYSSVC_CFLAGS: []const u8 = "",
    CFG_KERNEL: []const u8 = "",
    CFG_TABS: []const u8 = "",
    CFGOBJ: []const u8 = "",
    APPL_OBJS: []const u8 = "",
    SYSSVC_OBJS: []const u8 = "",
    ALL_OBJS: []const u8 = "",
    ALL_LIBS: []const u8 = "",
    LIBS_DEP: []const u8 = "",
    REALCLEAN_FILES: []const u8 = "",
    TARGET_CHECK_TRB: []const u8 = "",
    TECS_CPP: []const u8 = "",
    TECSGEN_SRCS: []const u8 = "",
    TECS_HEADERS: []const u8 = "",
    ZIGCFG: []const u8 = "",
    BANNEROBJ: []const u8 = "",
    MODE: []const u8 = "",
    BUILDDIR: []const u8 = "",
    APPLOBJS: []const u8 = "",
    SYSSVCOBJS: []const u8 = "",
    TECS_COBJS: []const u8 = "",
    START_OBJS: []const u8 = "",
    END_OBJS: []const u8 = "",
    HIDDEN_OBJS: []const u8 = "",
    TEXT_START_ADDRESS: []const u8 = "",
    DATA_START_ADDRESS: []const u8 = "",
    LDSCRIPT: []const u8 = "",
    TOOL: []const u8 = "",
    GCC_TARGET: []const u8 = "",
    GCC_TARGET_PREFIX: []const u8 = "",
    CC: []const u8 = "",
    CXX: []const u8 = "",
    AS: []const u8 = "",
    LD: []const u8 = "",
    AR: []const u8 = "",
    NM: []const u8 = "",
    RANLIB: []const u8 = "",
    OBJCOPY: []const u8 = "",
    OBJDUMP: []const u8 = "",
    LINK: []const u8 = "",

    //     // このstruct内に，memberで指定した名前のメンバ変数が存在するか返す
    //     // 値が代入されていない場合はfalse
    //     fn ifdef(self: *@This(), member: []const u8) bool {
    //         return @hasDecl(self, member);
    //     }
};

///
/// ビルド処理本体
///
pub fn build(b: *std.Build) !void {
    // Zigを用いたビルドのためのターゲット指定と最適化設定
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .arm,
        .os_tag = .freestanding,
        .abi = .eabi,
    });
    const optimize = b.standardOptimizeOption(.{});

    // 定義用変数の初期化
    var cfg_var: configuration_variables = .{};
    cfg_var.TARGET = "ct11mocore_gcc";
    cfg_var.APPL_ZIGOBJS = "sample1.o";
    cfg_var.OBJDIR = "objs";

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

    // includeディレクトリのroot.zigをモジュールとして登録
    const include_mod = b.createModule(.{
        .root_source_file = .{ .path = "../include/root.zig" },
    });

    // targetディレクトリのroot.zigをモジュールとして登録
    const target_mod = b.createModule(.{
        .root_source_file = .{ .path = "../target/root.zig" },
    });

    // kernel, library, arch, include, targetディレクトリに関する.zig間の依存関係
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
    target_mod.addImport("include", include_mod);
    target_mod.addImport("target", target_mod);
    arch_mod.addImport("kernel", kernel_mod);
    arch_mod.addImport("arch", arch_mod);
    arch_mod.addImport("include", include_mod);

    // C言語ヘッダのインクルードディレクトリを設定
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

    // アプリケーションビルド用ディレクトリのtecsgen_cfg.zigをモジュールとして登録
    const objarm_mod = b.createModule(.{
        .root_source_file = .{ .path = "../OBJ-ARM/gen/tecsgen_cfg.zig" },
    });

    // アプリケーションビルド用ディレクトリに関わる依存関係
    objarm_mod.addImport("kernel", kernel_mod);
    objarm_mod.addImport("target", target_mod);
    target_mod.addImport("objarm", objarm_mod);

    // const configure = b.addSystemCommand(&.{ "../configure.rb", "-T", "ct11mpcore_gcc", "-O", "-DTOPPERS_USE_QEMU" });
    // configure.setCwd(b.path("OBJ-ARM"));
    // const tecsgen = b.addSystemCommand(&.{ "ruby", SRCDIR ++ "/tecsgen/tecsgen.rb", "sample/sample1.cdl", "-R", "-I.", "-Iinclude", "-Itarget/ct11mpcore_gcc", "-Iarch/arm_gcc/common", "-Iarch/gcc", "-I..", "-Isample", "-I./gen", "-Itecs_kernel", "--cpp", "arm-none-eabi-gcc", "-D__TARGET_ARCH_ARM=6", "-DTOPPERS_USE_QEMU", "-I.", "-Iinclude", "-Itarget/ct11mpcore_gcc", "-Iarch/arm_gcc/common", "-Iarch/gcc", "-I..", "-Isample", "-I./gen", "-Itecs_kernel -D TECSGEN -E", "-g", "./gen " });
    // tecsgen.setCwd(b.path("OBJ-ARM"));
    // tecsgen.step.dependOn(&configure.step);

    // アプリケーションコンフィギュレーションのオブジェクトファイル生成
    // sample1_cfg.o生成ステップ
    const obj = b.addObject(.{
        .name = "sample1_cfg",
        .root_source_file = .{ .path = "../sample/sample1_cfg.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });

    // sample/sample1_cfg.zigが@importしているモジュールへのパスを通す
    obj.root_module.addImport("kernel", kernel_mod);
    obj.root_module.addImport("objarm", objarm_mod);

    // マクロ定義の追加
    obj.defineCMacro("__TARGET_ARCH_ARM", "6");
    obj.defineCMacro("TOPPERS_USE_QEMU", null);

    // C言語ヘッダへのパスを通す
    for (include_dirs) |path_h| {
        objarm_mod.addIncludePath(b.path(path_h));
        obj.addIncludePath(b.path(path_h));
    }

    // sample1_cfg.oをobjs/に配置
    const obj_install_step = b.addInstallBinFile(obj.getEmittedBin(), "../../objs/sample1_cfg.o");

    // "obj"としてsample1_cfg.o生成ステップを実行できるように設定
    const build_applobj = b.step("obj", "Build object file");
    build_applobj.dependOn(&obj_install_step.step);

    // カーネルライブラリファイルの生成

    // libkernel.a生成ステップ
    const lib = b.addStaticLibrary(.{
        .name = "kernel",
        .root_source_file = .{ .path = "../kernel/c_api.zig" },
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });

    // kernel/c_api.zigが@importしているモジュールへのパスを通す
    lib.root_module.addImport("kernel", kernel_mod);
    lib.root_module.addImport("library", library_mod);

    // C言語マクロ定義（必要なければ消す）
    lib.defineCMacro("__TARGET_ARCH_ARM", "6");
    lib.defineCMacro("TOPPERS_USE_QEMU", null);

    // libraryモジュールが依存しているC言語ヘッダへのパスを通す
    for (include_dirs) |path_h| {
        lib.addIncludePath(b.path(path_h));
        library_mod.addIncludePath(b.path(path_h));
    }

    // libkernel.aをOBJ-ARM/に配置
    const lib_install_step = b.addInstallBinFile(lib.getEmittedBin(), "../../libkernel.a");

    // libkernel.aからkernel.oを生成
    const gen_kernel_ar = b.addSystemCommand(&.{ "ar", "x", "libkernel.a", "kernel.o" }); // arコマンドを使用
    gen_kernel_ar.step.dependOn(&lib_install_step.step); // libkernel.a生成ステップの後に実行

    // "lib"としてlibkernel.a, kernel.o生成ステップを実行できるように設定
    const build_libkernel = b.step("lib", "Build kenrel library .a .o");
    build_libkernel.dependOn(&gen_kernel_ar.step);
}
