const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .arm,
        .os_tag = .freestanding,
        .abi = .eabi,
    });

    const optimize = b.standardOptimizeOption(.{});

    // オブジェクトファイルを生成
    const obj = b.addObject((.{
        .name = "sample1_cfg",
        .root_source_file = .{ .path = "./sample/sample1_cfg.zig" },
        .target = target,
        .optimize = optimize,
    }));

    // 各ディレクトリのroot.zigをモジュールとして登録
    // kernelディレクトリのroot.zigをモジュールとして登録
    const kernel_mod = b.createModule(.{
        .root_source_file = .{ .path = "./kernel/root.zig" },
    });
    obj.root_module.addImport("kernel", kernel_mod);

    // libraryディレクトリのroot.zigをモジュールとして登録
    const library_mod = b.createModule(.{
        .root_source_file = .{ .path = "./library/root.zig" },
    });
    obj.root_module.addImport("library", library_mod);

    // archディレクトリのroot.zigをモジュールとして登録
    const arch_mod = b.createModule(.{
        .root_source_file = .{ .path = "./arch/root.zig" },
    });
    obj.root_module.addImport("arch", arch_mod);

    // OBJ-ARMディレクトリのroot.zigをモジュールとして登録
    const objarm_mod = b.createModule(.{
        .root_source_file = .{ .path = "./OBJ-ARM/root.zig" },
    });
    obj.root_module.addImport("objarm", objarm_mod);

    // includeディレクトリのroot.zigをモジュールとして登録
    const include_mod = b.createModule(.{
        .root_source_file = .{ .path = "./include/root.zig" },
    });
    obj.root_module.addImport("include", include_mod);

    // targetディレクトリのroot.zigをモジュールとして登録
    const target_mod = b.createModule(.{
        .root_source_file = .{ .path = "./target/root.zig" },
    });

    kernel_mod.addImport("include", include_mod);
    kernel_mod.addImport("target", target_mod);
    kernel_mod.addImport("kernel", kernel_mod);
    kernel_mod.addImport("library", library_mod);
    target_mod.addImport("arch", arch_mod);
    target_mod.addImport("kernel", kernel_mod);
    include_mod.addImport("target", target_mod);
    include_mod.addImport("include", include_mod);
    arch_mod.addImport("arch", arch_mod);
    arch_mod.addImport("kernel", kernel_mod);
    objarm_mod.addImport("kernel", kernel_mod);

    // マクロ定義の追加
    obj.defineCMacro("TARGET", "\"ct11mpcore_gcc\"");
    obj.defineCMacro("SRCDIR", "\".\"");
    obj.defineCMacro("TECSGENDIR", "\"OBJ-ARM/gen\"");
    obj.defineCMacro("__TARGET_ARCH_ARM", "6");
    obj.defineCMacro("TOPPERS_USE_QEMU", null);

    // インクルードディレクトリの追加
    obj.addIncludePath(.{ .path = "." });
    obj.addIncludePath(.{ .path = "./include" });
    obj.addIncludePath(.{ .path = "./target/ct11mpcore_gcc" });
    obj.addIncludePath(.{ .path = "./arch/arm_gcc/common" });
    obj.addIncludePath(.{ .path = "./arch/gcc" });
    obj.addIncludePath(.{ .path = "./sample" });
    obj.addIncludePath(.{ .path = "./OBJ-ARM/gen" });
    obj.addIncludePath(.{ .path = "./tecs_kernel" });

    // objsディレクトリにsample1_cfg.oをコピー
    const install_step = b.addInstallFileWithDir(obj.getEmittedBin(), .{ .custom = "OBJ-ARM/objs" }, "sample1_cfg.o");

    // zig buildの一部としてinstall_stepを実行
    b.getInstallStep().dependOn(&install_step.step);
}
