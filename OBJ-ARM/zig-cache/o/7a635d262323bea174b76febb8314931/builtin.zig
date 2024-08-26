const std = @import("std");
/// Zig version. When writing code that supports multiple versions of Zig, prefer
/// feature detection (i.e. with `@hasDecl` or `@hasField`) over version checks.
pub const zig_version = std.SemanticVersion.parse("0.10.1") catch unreachable;
pub const zig_backend = std.builtin.CompilerBackend.stage2_llvm;

pub const output_mode = std.builtin.OutputMode.Obj;
pub const link_mode = std.builtin.LinkMode.Static;
pub const is_test = false;
pub const single_threaded = false;
pub const abi = std.Target.Abi.eabi;
pub const cpu: std.Target.Cpu = .{
    .arch = .arm,
    .model = &std.Target.arm.cpu.mpcore,
    .features = std.Target.arm.featureSet(&[_]std.Target.arm.Feature{
        .fp64,
        .fpregs,
        .fpregs64,
        .has_v4t,
        .has_v5t,
        .has_v5te,
        .has_v6,
        .has_v6k,
        .slowfpvmlx,
        .v6k,
        .vfp2,
        .vfp2sp,
    }),
};
pub const os = std.Target.Os{
    .tag = .freestanding,
    .version_range = .{ .none = {} },
};
pub const target = std.Target{
    .cpu = cpu,
    .os = os,
    .abi = abi,
    .ofmt = object_format,
};
pub const object_format = std.Target.ObjectFormat.elf;
pub const mode = std.builtin.Mode.ReleaseSafe;
pub const link_libc = false;
pub const link_libcpp = false;
pub const have_error_return_tracing = true;
pub const valgrind_support = false;
pub const sanitize_thread = false;
pub const position_independent_code = false;
pub const position_independent_executable = false;
pub const strip_debug_info = false;
pub const code_model = std.builtin.CodeModel.default;
