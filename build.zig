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

    // @importのモジュールと依存関係を追加
    const library_strerror_mod = b.addModule("library_strerror", .{
        .root_source_file = .{ .path = "library/strerror.zig" },
    });
    const library_errorcode_mod = b.addModule("library_errorcode", .{
        .root_source_file = .{ .path = "library/errorcode.zig" },
    });
    const include_option_mod = b.addModule("include_option", .{
        .root_source_file = .{ .path = "include/option.zig" },
    });
    const include_kernel_mod = b.addModule("include_kernel", .{
        .root_source_file = .{ .path = "include/kernel.zig" },
    });
    const target_ct11mpcore_gcc_target_cfg_mod = b.addModule("target_ct11mpcore_gcc_target_cfg", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/target_cfg.zig" },
    });
    const include_t_syslog_mod = b.addModule("include_t_syslog", .{
        .root_source_file = .{ .path = "include/t_syslog.zig" },
    });
    const target_ct11mpcore_gcc_target_kernel_impl_mod = b.addModule("target_ct11mpcore_gcc_target_kernel_impl", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/target_kernel_impl.zig" },
    });
    const target_ct11mpcore_gcc_target_timer_mod = b.addModule("target_ct11mpcore_gcc_target_timer", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/target_timer.zig" },
    });
    const include_sil_mod = b.addModule("include_sil", .{
        .root_source_file = .{ .path = "include/sil.zig" },
    });
    const library_queue_mod = b.addModule("library_queue", .{
        .root_source_file = .{ .path = "library/queue.zig" },
    });
    const library_prio_bitmap_mod = b.addModule("library_prio_bitmap", .{
        .root_source_file = .{ .path = "library/prio_bitmap.zig" },
    });
    const target_ct11mpcore_gcc_target_sil_mod = b.addModule("target_ct11mpcore_gcc_target_sil", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/target_sil.zig" },
    });
    const arch_tracelog_trace_option_mod = b.addModule("arch_tracelog_trace_option", .{
        .root_source_file = .{ .path = "arch/tracelog/trace_option.zig" },
    });
    const target_ct11mpcore_gcc_target_option_mod = b.addModule("target_ct11mpcore_gcc_target_option", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/target_option.zig" },
    });
    const target_ct11mpcore_gcc_target_stddef_mod = b.addModule("target_ct11mpcore_gcc_target_stddef", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/target_stddef.zig" },
    });
    const target_ct11mpcore_gcc_target_kernel_mod = b.addModule("target_ct11mpcore_gcc_target_kernel", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/target_kernel.zig" },
    });
    const arch_arm_gcc_common_core_sil_mod = b.addModule("arch_arm_gcc_common_core_sil", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/core_sil.zig" },
    });
    const arch_arm_gcc_zynq7000_chip_kernel_impl_mod = b.addModule("arch_arm_gcc_zynq7000_chip_kernel_impl", .{
        .root_source_file = .{ .path = "arch/arm_gcc/zynq7000/chip_kernel_impl.zig" },
    });
    const arch_arm_gcc_common_arm_mod = b.addModule("arch_arm_gcc_common_arm", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/arm.zig" },
    });
    const arch_arm_gcc_common_pl310_mod = b.addModule("arch_arm_gcc_common_pl310", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/pl310.zig" },
    });
    const arch_arm_gcc_zynq7000_chip_kernel_mod = b.addModule("arch_arm_gcc_zynq7000_chip_kernel", .{
        .root_source_file = .{ .path = "arch/arm_gcc/zynq7000/chip_kernel.zig" },
    });
    const arch_arm_gcc_common_core_option_mod = b.addModule("arch_arm_gcc_common_core_option", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/core_option.zig" },
    });
    const arch_arm_gcc_zynq7000_zynq7000_mod = b.addModule("arch_arm_gcc_zynq7000_zynq7000", .{
        .root_source_file = .{ .path = "arch/arm_gcc/zynq7000/zynq7000.zig" },
    });
    const arch_arm_gcc_common_mpcore_mod = b.addModule("arch_arm_gcc_common_mpcore", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/mpcore.zig" },
    });
    const arch_arm_gcc_zynq7000_chip_timer_mod = b.addModule("arch_arm_gcc_zynq7000_chip_timer", .{
        .root_source_file = .{ .path = "arch/arm_gcc/zynq7000/chip_timer.zig" },
    });
    const arch_arm_gcc_zynq7000_chip_stddef_mod = b.addModule("arch_arm_gcc_zynq7000_chip_stddef", .{
        .root_source_file = .{ .path = "arch/arm_gcc/zynq7000/chip_stddef.zig" },
    });
    const arch_arm_gcc_zynq7000_chip_cfg_mod = b.addModule("arch_arm_gcc_zynq7000_chip_cfg", .{
        .root_source_file = .{ .path = "arch/arm_gcc/zynq7000/chip_cfg.zig" },
    });
    const arch_arm_gcc_rza1_chip_kernel_impl_mod = b.addModule("arch_arm_gcc_rza1_chip_kernel_impl", .{
        .root_source_file = .{ .path = "arch/arm_gcc/rza1/chip_kernel_impl.zig" },
    });
    const arch_arm_gcc_rza1_rza1_mod = b.addModule("arch_arm_gcc_rza1_rza1", .{
        .root_source_file = .{ .path = "arch/arm_gcc/rza1/rza1.zig" },
    });
    const arch_arm_gcc_rza1_chip_kernel_mod = b.addModule("arch_arm_gcc_rza1_chip_kernel", .{
        .root_source_file = .{ .path = "arch/arm_gcc/rza1/chip_kernel.zig" },
    });
    const arch_arm_gcc_rza1_chip_timer_mod = b.addModule("arch_arm_gcc_rza1_chip_timer", .{
        .root_source_file = .{ .path = "arch/arm_gcc/rza1/chip_timer.zig" },
    });
    const arch_arm_gcc_rza1_chip_stddef_mod = b.addModule("arch_arm_gcc_rza1_chip_stddef", .{
        .root_source_file = .{ .path = "arch/arm_gcc/rza1/chip_stddef.zig" },
    });
    const arch_arm_gcc_rza1_chip_cfg_mod = b.addModule("arch_arm_gcc_rza1_chip_cfg", .{
        .root_source_file = .{ .path = "arch/arm_gcc/rza1/chip_cfg.zig" },
    });
    const kernel_kernel_impl_mod = b.addModule("kernel_kernel_impl", .{
        .root_source_file = .{ .path = "kernel/kernel_impl.zig" },
    });
    const arch_arm_gcc_common_mpcore_kernel_impl_mod = b.addModule("arch_arm_gcc_common_mpcore_kernel_impl", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/mpcore_kernel_impl.zig" },
    });
    const arch_arm_gcc_common_core_kernel_mod = b.addModule("arch_arm_gcc_common_core_kernel", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/core_kernel.zig" },
    });
    const arch_arm_gcc_common_mpcore_timer_mod = b.addModule("arch_arm_gcc_common_mpcore_timer", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/mpcore_timer.zig" },
    });
    const kernel_kernel_cfg_mod = b.addModule("kernel_kernel_cfg", .{
        .root_source_file = .{ .path = "kernel/kernel_cfg.zig" },
    });
    const target_ct11mpcore_gcc_ct11mpcore_mod = b.addModule("target_ct11mpcore_gcc_ct11mpcore", .{
        .root_source_file = .{ .path = "target/ct11mpcore_gcc/ct11mpcore.zig" },
    });
    const arch_simtimer_sim_timer_mod = b.addModule("arch_simtimer_sim_timer", .{
        .root_source_file = .{ .path = "arch/simtimer/sim_timer.zig" },
    });
    const arch_simtimer_sim_timer_cfg_mod = b.addModule("arch_simtimer_sim_timer_cfg", .{
        .root_source_file = .{ .path = "arch/simtimer/sim_timer_cfg.zig" },
    });
    const OBJ_ARM_gen_tecsgen_cfg_mod = b.addModule("OBJ_ARM_gen_tecsgen_cfg", .{
        .root_source_file = .{ .path = "OBJ-ARM/gen/tecsgen_cfg.zig" },
    });
    const include_t_stddef_mod = b.addModule("include_t_stddef", .{
        .root_source_file = .{ .path = "include/t_stddef.zig" },
    });
    const arch_arm_gcc_common_core_kernel_impl_mod = b.addModule("arch_arm_gcc_common_core_kernel_impl", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/core_kernel_impl.zig" },
    });
    const kernel_static_api_mod = b.addModule("kernel_static_api", .{
        .root_source_file = .{ .path = "kernel/static_api.zig" },
    });
    kernel_static_api_mod.addImport("library_strerror", library_strerror_mod);
    const kernel_c_api_mod = b.addModule("kernel_c_api", .{
        .root_source_file = .{ .path = "kernel/c_api.zig" },
    });
    kernel_c_api_mod.addImport("library_errorcode", library_errorcode_mod);
    kernel_kernel_cfg_mod.addImport("include_option", include_option_mod);
    kernel_kernel_cfg_mod.addImport("include_kernel", include_kernel_mod);
    kernel_kernel_cfg_mod.addImport("target_ct11mpcore_gcc_target_cfg", target_ct11mpcore_gcc_target_cfg_mod);
    kernel_kernel_impl_mod.addImport("include_option", include_option_mod);
    kernel_kernel_impl_mod.addImport("include_kernel", include_kernel_mod);
    kernel_kernel_impl_mod.addImport("include_t_syslog", include_t_syslog_mod);
    kernel_kernel_impl_mod.addImport("target_ct11mpcore_gcc_target_kernel_impl", target_ct11mpcore_gcc_target_kernel_impl_mod);
    kernel_kernel_impl_mod.addImport("target_ct11mpcore_gcc_target_timer", target_ct11mpcore_gcc_target_timer_mod);
    kernel_kernel_impl_mod.addImport("include_sil", include_sil_mod);
    kernel_kernel_impl_mod.addImport("library_queue", library_queue_mod);
    kernel_kernel_impl_mod.addImport("library_prio_bitmap", library_prio_bitmap_mod);
    include_sil_mod.addImport("include_option", include_option_mod);
    include_sil_mod.addImport("target_ct11mpcore_gcc_target_sil", target_ct11mpcore_gcc_target_sil_mod);
    include_option_mod.addImport("arch_tracelog_trace_option", arch_tracelog_trace_option_mod);
    include_option_mod.addImport("target_ct11mpcore_gcc_target_option", target_ct11mpcore_gcc_target_option_mod);
    include_t_stddef_mod.addImport("include_option", include_option_mod);
    include_t_stddef_mod.addImport("target_ct11mpcore_gcc_target_stddef", target_ct11mpcore_gcc_target_stddef_mod);
    include_kernel_mod.addImport("include_option", include_option_mod);
    include_kernel_mod.addImport("target_ct11mpcore_gcc_target_kernel", target_ct11mpcore_gcc_target_kernel_mod);
    const target_zybo_z7_gcc_target_sil_mod = b.addModule("target_zybo_z7_gcc_target_sil", .{
        .root_source_file = .{ .path = "target/zybo_z7_gcc/target_sil.zig" },
    });
    target_zybo_z7_gcc_target_sil_mod.addImport("arch_arm_gcc_common_core_sil", arch_arm_gcc_common_core_sil_mod);
    const target_zybo_z7_gcc_target_kernel_impl_mod = b.addModule("target_zybo_z7_gcc_target_kernel_impl", .{
        .root_source_file = .{ .path = "target/zybo_z7_gcc/target_kernel_impl.zig" },
    });
    target_zybo_z7_gcc_target_kernel_impl_mod.addImport("include_option", include_option_mod);
    target_zybo_z7_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_zynq7000_chip_kernel_impl", arch_arm_gcc_zynq7000_chip_kernel_impl_mod);
    target_zybo_z7_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_common_arm", arch_arm_gcc_common_arm_mod);
    target_zybo_z7_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_common_pl310", arch_arm_gcc_common_pl310_mod);
    const target_zybo_z7_gcc_target_kernel_mod = b.addModule("target_zybo_z7_gcc_target_kernel", .{
        .root_source_file = .{ .path = "target/zybo_z7_gcc/target_kernel.zig" },
    });
    target_zybo_z7_gcc_target_kernel_mod.addImport("arch_arm_gcc_zynq7000_chip_kernel", arch_arm_gcc_zynq7000_chip_kernel_mod);
    const target_zybo_z7_gcc_target_option_mod = b.addModule("target_zybo_z7_gcc_target_option", .{
        .root_source_file = .{ .path = "target/zybo_z7_gcc/target_option.zig" },
    });
    target_zybo_z7_gcc_target_option_mod.addImport("arch_arm_gcc_common_core_option", arch_arm_gcc_common_core_option_mod);
    target_zybo_z7_gcc_target_option_mod.addImport("arch_arm_gcc_zynq7000_zynq7000", arch_arm_gcc_zynq7000_zynq7000_mod);
    target_zybo_z7_gcc_target_option_mod.addImport("arch_arm_gcc_common_mpcore", arch_arm_gcc_common_mpcore_mod);
    target_zybo_z7_gcc_target_option_mod.addImport("include_kernel", include_kernel_mod);
    const target_zybo_z7_gcc_target_timer_mod = b.addModule("target_zybo_z7_gcc_target_timer", .{
        .root_source_file = .{ .path = "target/zybo_z7_gcc/target_timer.zig" },
    });
    target_zybo_z7_gcc_target_timer_mod.addImport("arch_arm_gcc_zynq7000_chip_timer", arch_arm_gcc_zynq7000_chip_timer_mod);
    const target_zybo_z7_gcc_target_stddef_mod = b.addModule("target_zybo_z7_gcc_target_stddef", .{
        .root_source_file = .{ .path = "target/zybo_z7_gcc/target_stddef.zig" },
    });
    target_zybo_z7_gcc_target_stddef_mod.addImport("include_option", include_option_mod);
    target_zybo_z7_gcc_target_stddef_mod.addImport("arch_arm_gcc_zynq7000_chip_stddef", arch_arm_gcc_zynq7000_chip_stddef_mod);
    const target_zybo_z7_gcc_target_cfg_mod = b.addModule("target_zybo_z7_gcc_target_cfg", .{
        .root_source_file = .{ .path = "target/zybo_z7_gcc/target_cfg.zig" },
    });
    target_zybo_z7_gcc_target_cfg_mod.addImport("arch_arm_gcc_zynq7000_chip_cfg", arch_arm_gcc_zynq7000_chip_cfg_mod);
    const target_gr_peach_gcc_target_sil_mod = b.addModule("target_gr_peach_gcc_target_sil", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/target_sil.zig" },
    });
    target_gr_peach_gcc_target_sil_mod.addImport("arch_arm_gcc_common_core_sil", arch_arm_gcc_common_core_sil_mod);
    const target_gr_peach_gcc_target_kernel_impl_mod = b.addModule("target_gr_peach_gcc_target_kernel_impl", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/target_kernel_impl.zig" },
    });
    target_gr_peach_gcc_target_kernel_impl_mod.addImport("include_option", include_option_mod);
    target_gr_peach_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_rza1_chip_kernel_impl", arch_arm_gcc_rza1_chip_kernel_impl_mod);
    target_gr_peach_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_rza1_rza1", arch_arm_gcc_rza1_rza1_mod);
    target_gr_peach_gcc_target_kernel_impl_mod.addImport("include_sil", include_sil_mod);
    target_gr_peach_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_common_arm", arch_arm_gcc_common_arm_mod);
    target_gr_peach_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_common_pl310", arch_arm_gcc_common_pl310_mod);
    const target_gr_peach_gcc_target_kernel_mod = b.addModule("target_gr_peach_gcc_target_kernel", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/target_kernel.zig" },
    });
    target_gr_peach_gcc_target_kernel_mod.addImport("arch_arm_gcc_rza1_chip_kernel", arch_arm_gcc_rza1_chip_kernel_mod);
    const target_gr_peach_gcc_target_option_mod = b.addModule("target_gr_peach_gcc_target_option", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/target_option.zig" },
    });
    target_gr_peach_gcc_target_option_mod.addImport("arch_arm_gcc_common_core_option", arch_arm_gcc_common_core_option_mod);
    target_gr_peach_gcc_target_option_mod.addImport("arch_arm_gcc_rza1_rza1", arch_arm_gcc_rza1_rza1_mod);
    target_gr_peach_gcc_target_option_mod.addImport("arch_arm_gcc_common_mpcore", arch_arm_gcc_common_mpcore_mod);
    target_gr_peach_gcc_target_option_mod.addImport("include_kernel", include_kernel_mod);
    const target_gr_peach_gcc_target_timer_mod = b.addModule("target_gr_peach_gcc_target_timer", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/target_timer.zig" },
    });
    target_gr_peach_gcc_target_timer_mod.addImport("arch_arm_gcc_rza1_chip_timer", arch_arm_gcc_rza1_chip_timer_mod);
    const target_gr_peach_gcc_gr_peach_mod = b.addModule("target_gr_peach_gcc_gr_peach", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/gr_peach.zig" },
    });
    target_gr_peach_gcc_gr_peach_mod.addImport("arch_arm_gcc_rza1_rza1", arch_arm_gcc_rza1_rza1_mod);
    const target_gr_peach_gcc_target_stddef_mod = b.addModule("target_gr_peach_gcc_target_stddef", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/target_stddef.zig" },
    });
    target_gr_peach_gcc_target_stddef_mod.addImport("arch_arm_gcc_rza1_chip_stddef", arch_arm_gcc_rza1_chip_stddef_mod);
    const target_gr_peach_gcc_target_cfg_mod = b.addModule("target_gr_peach_gcc_target_cfg", .{
        .root_source_file = .{ .path = "target/gr_peach_gcc/target_cfg.zig" },
    });
    target_gr_peach_gcc_target_cfg_mod.addImport("arch_arm_gcc_rza1_chip_cfg", arch_arm_gcc_rza1_chip_cfg_mod);
    target_ct11mpcore_gcc_target_sil_mod.addImport("arch_arm_gcc_common_core_sil", arch_arm_gcc_common_core_sil_mod);
    target_ct11mpcore_gcc_target_kernel_impl_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    target_ct11mpcore_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_common_mpcore_kernel_impl", arch_arm_gcc_common_mpcore_kernel_impl_mod);
    target_ct11mpcore_gcc_target_kernel_impl_mod.addImport("arch_arm_gcc_common_arm", arch_arm_gcc_common_arm_mod);
    target_ct11mpcore_gcc_target_kernel_mod.addImport("arch_arm_gcc_common_core_kernel", arch_arm_gcc_common_core_kernel_mod);
    target_ct11mpcore_gcc_target_option_mod.addImport("arch_arm_gcc_common_core_option", arch_arm_gcc_common_core_option_mod);
    target_ct11mpcore_gcc_target_option_mod.addImport("arch_arm_gcc_common_mpcore", arch_arm_gcc_common_mpcore_mod);
    target_ct11mpcore_gcc_target_option_mod.addImport("include_kernel", include_kernel_mod);
    target_ct11mpcore_gcc_target_timer_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    target_ct11mpcore_gcc_target_timer_mod.addImport("arch_arm_gcc_common_mpcore_timer", arch_arm_gcc_common_mpcore_timer_mod);
    target_ct11mpcore_gcc_target_stddef_mod.addImport("include_option", include_option_mod);
    target_ct11mpcore_gcc_target_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    target_ct11mpcore_gcc_ct11mpcore_mod.addImport("include_option", include_option_mod);
    const target_simtimer_ct11mpcore_gcc_target_sil_mod = b.addModule("target_simtimer_ct11mpcore_gcc_target_sil", .{
        .root_source_file = .{ .path = "target/simtimer_ct11mpcore_gcc/target_sil.zig" },
    });
    target_simtimer_ct11mpcore_gcc_target_sil_mod.addImport("target_ct11mpcore_gcc_target_sil", target_ct11mpcore_gcc_target_sil_mod);
    const target_simtimer_ct11mpcore_gcc_target_kernel_impl_mod = b.addModule("target_simtimer_ct11mpcore_gcc_target_kernel_impl", .{
        .root_source_file = .{ .path = "target/simtimer_ct11mpcore_gcc/target_kernel_impl.zig" },
    });
    target_simtimer_ct11mpcore_gcc_target_kernel_impl_mod.addImport("target_ct11mpcore_gcc_target_kernel_impl", target_ct11mpcore_gcc_target_kernel_impl_mod);
    const target_simtimer_ct11mpcore_gcc_target_kernel_mod = b.addModule("target_simtimer_ct11mpcore_gcc_target_kernel", .{
        .root_source_file = .{ .path = "target/simtimer_ct11mpcore_gcc/target_kernel.zig" },
    });
    target_simtimer_ct11mpcore_gcc_target_kernel_mod.addImport("arch_arm_gcc_common_core_kernel", arch_arm_gcc_common_core_kernel_mod);
    const target_simtimer_ct11mpcore_gcc_target_option_mod = b.addModule("target_simtimer_ct11mpcore_gcc_target_option", .{
        .root_source_file = .{ .path = "target/simtimer_ct11mpcore_gcc/target_option.zig" },
    });
    target_simtimer_ct11mpcore_gcc_target_option_mod.addImport("target_ct11mpcore_gcc_target_option", target_ct11mpcore_gcc_target_option_mod);
    const target_simtimer_ct11mpcore_gcc_target_timer_mod = b.addModule("target_simtimer_ct11mpcore_gcc_target_timer", .{
        .root_source_file = .{ .path = "target/simtimer_ct11mpcore_gcc/target_timer.zig" },
    });
    target_simtimer_ct11mpcore_gcc_target_timer_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    target_simtimer_ct11mpcore_gcc_target_timer_mod.addImport("target_ct11mpcore_gcc_ct11mpcore", target_ct11mpcore_gcc_ct11mpcore_mod);
    target_simtimer_ct11mpcore_gcc_target_timer_mod.addImport("arch_arm_gcc_common_mpcore", arch_arm_gcc_common_mpcore_mod);
    target_simtimer_ct11mpcore_gcc_target_timer_mod.addImport("arch_simtimer_sim_timer", arch_simtimer_sim_timer_mod);
    const target_simtimer_ct11mpcore_gcc_target_stddef_mod = b.addModule("target_simtimer_ct11mpcore_gcc_target_stddef", .{
        .root_source_file = .{ .path = "target/simtimer_ct11mpcore_gcc/target_stddef.zig" },
    });
    target_simtimer_ct11mpcore_gcc_target_stddef_mod.addImport("target_ct11mpcore_gcc_target_stddef", target_ct11mpcore_gcc_target_stddef_mod);
    const target_simtimer_ct11mpcore_gcc_target_cfg_mod = b.addModule("target_simtimer_ct11mpcore_gcc_target_cfg", .{
        .root_source_file = .{ .path = "target/simtimer_ct11mpcore_gcc/target_cfg.zig" },
    });
    target_simtimer_ct11mpcore_gcc_target_cfg_mod.addImport("arch_simtimer_sim_timer_cfg", arch_simtimer_sim_timer_cfg_mod);
    const target_dummy_gcc_target_kernel_impl_mod = b.addModule("target_dummy_gcc_target_kernel_impl", .{
        .root_source_file = .{ .path = "target/dummy_gcc/target_kernel_impl.zig" },
    });
    target_dummy_gcc_target_kernel_impl_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    const target_dummy_gcc_target_timer_mod = b.addModule("target_dummy_gcc_target_timer", .{
        .root_source_file = .{ .path = "target/dummy_gcc/target_timer.zig" },
    });
    target_dummy_gcc_target_timer_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    const target_dummy_gcc_target_cfg_mod = b.addModule("target_dummy_gcc_target_cfg", .{
        .root_source_file = .{ .path = "target/dummy_gcc/target_cfg.zig" },
    });
    target_dummy_gcc_target_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    const test_test_raster1_cfg_mod = b.addModule("test_test_raster1_cfg", .{
        .root_source_file = .{ .path = "test/test_raster1_cfg.zig" },
    });
    test_test_raster1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_raster1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_int1_cfg_mod = b.addModule("test_test_int1_cfg", .{
        .root_source_file = .{ .path = "test/test_int1_cfg.zig" },
    });
    test_test_int1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_int1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_ovrhdr2_cfg_mod = b.addModule("test_test_ovrhdr2_cfg", .{
        .root_source_file = .{ .path = "test/test_ovrhdr2_cfg.zig" },
    });
    test_test_ovrhdr2_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_ovrhdr2_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_perf1_cfg_mod = b.addModule("test_perf1_cfg", .{
        .root_source_file = .{ .path = "test/perf1_cfg.zig" },
    });
    test_perf1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_perf1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_simt_systim2_cfg_mod = b.addModule("test_simt_systim2_cfg", .{
        .root_source_file = .{ .path = "test/simt_systim2_cfg.zig" },
    });
    test_simt_systim2_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_simt_systim2_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_dtq1_cfg_mod = b.addModule("test_test_dtq1_cfg", .{
        .root_source_file = .{ .path = "test/test_dtq1_cfg.zig" },
    });
    test_test_dtq1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_dtq1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_dlynse_cfg_mod = b.addModule("test_test_dlynse_cfg", .{
        .root_source_file = .{ .path = "test/test_dlynse_cfg.zig" },
    });
    test_test_dlynse_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_dlynse_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_perf4_cfg_mod = b.addModule("test_perf4_cfg", .{
        .root_source_file = .{ .path = "test/perf4_cfg.zig" },
    });
    test_perf4_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_perf4_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_exttsk_cfg_mod = b.addModule("test_test_exttsk_cfg", .{
        .root_source_file = .{ .path = "test/test_exttsk_cfg.zig" },
    });
    test_test_exttsk_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_exttsk_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_perf3_cfg_mod = b.addModule("test_perf3_cfg", .{
        .root_source_file = .{ .path = "test/perf3_cfg.zig" },
    });
    test_perf3_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_perf3_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_flg1_cfg_mod = b.addModule("test_test_flg1_cfg", .{
        .root_source_file = .{ .path = "test/test_flg1_cfg.zig" },
    });
    test_test_flg1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_flg1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex7_cfg_mod = b.addModule("test_test_mutex7_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex7_cfg.zig" },
    });
    test_test_mutex7_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex7_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_hrt1_cfg_mod = b.addModule("test_test_hrt1_cfg", .{
        .root_source_file = .{ .path = "test/test_hrt1_cfg.zig" },
    });
    test_test_hrt1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_hrt1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_tmevt1_cfg_mod = b.addModule("test_test_tmevt1_cfg", .{
        .root_source_file = .{ .path = "test/test_tmevt1_cfg.zig" },
    });
    test_test_tmevt1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_tmevt1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex2_cfg_mod = b.addModule("test_test_mutex2_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex2_cfg.zig" },
    });
    test_test_mutex2_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex2_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_ovrhdr1_cfg_mod = b.addModule("test_test_ovrhdr1_cfg", .{
        .root_source_file = .{ .path = "test/test_ovrhdr1_cfg.zig" },
    });
    test_test_ovrhdr1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_ovrhdr1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_notify1_cfg_mod = b.addModule("test_test_notify1_cfg", .{
        .root_source_file = .{ .path = "test/test_notify1_cfg.zig" },
    });
    test_test_notify1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_notify1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_sysstat1_cfg_mod = b.addModule("test_test_sysstat1_cfg", .{
        .root_source_file = .{ .path = "test/test_sysstat1_cfg.zig" },
    });
    test_test_sysstat1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_sysstat1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_task1_cfg_mod = b.addModule("test_test_task1_cfg", .{
        .root_source_file = .{ .path = "test/test_task1_cfg.zig" },
    });
    test_test_task1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_task1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex1_cfg_mod = b.addModule("test_test_mutex1_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex1_cfg.zig" },
    });
    test_test_mutex1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_simt_systim1_cfg_mod = b.addModule("test_simt_systim1_cfg", .{
        .root_source_file = .{ .path = "test/simt_systim1_cfg.zig" },
    });
    test_simt_systim1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_simt_systim1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex4_cfg_mod = b.addModule("test_test_mutex4_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex4_cfg.zig" },
    });
    test_test_mutex4_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex4_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_raster2_cfg_mod = b.addModule("test_test_raster2_cfg", .{
        .root_source_file = .{ .path = "test/test_raster2_cfg.zig" },
    });
    test_test_raster2_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_raster2_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_sysman1_cfg_mod = b.addModule("test_test_sysman1_cfg", .{
        .root_source_file = .{ .path = "test/test_sysman1_cfg.zig" },
    });
    test_test_sysman1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_sysman1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_sem2_cfg_mod = b.addModule("test_test_sem2_cfg", .{
        .root_source_file = .{ .path = "test/test_sem2_cfg.zig" },
    });
    test_test_sem2_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_sem2_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex8_cfg_mod = b.addModule("test_test_mutex8_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex8_cfg.zig" },
    });
    test_test_mutex8_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex8_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_ovrhdr4_cfg_mod = b.addModule("test_test_ovrhdr4_cfg", .{
        .root_source_file = .{ .path = "test/test_ovrhdr4_cfg.zig" },
    });
    test_test_ovrhdr4_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_ovrhdr4_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex3_cfg_mod = b.addModule("test_test_mutex3_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex3_cfg.zig" },
    });
    test_test_mutex3_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex3_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_suspend1_cfg_mod = b.addModule("test_test_suspend1_cfg", .{
        .root_source_file = .{ .path = "test/test_suspend1_cfg.zig" },
    });
    test_test_suspend1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_suspend1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_perf5_cfg_mod = b.addModule("test_perf5_cfg", .{
        .root_source_file = .{ .path = "test/perf5_cfg.zig" },
    });
    test_perf5_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_perf5_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_sem1_cfg_mod = b.addModule("test_test_sem1_cfg", .{
        .root_source_file = .{ .path = "test/test_sem1_cfg.zig" },
    });
    test_test_sem1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_sem1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_perf0_cfg_mod = b.addModule("test_perf0_cfg", .{
        .root_source_file = .{ .path = "test/perf0_cfg.zig" },
    });
    test_perf0_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_perf0_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_simt_systim4_cfg_mod = b.addModule("test_simt_systim4_cfg", .{
        .root_source_file = .{ .path = "test/simt_systim4_cfg.zig" },
    });
    test_simt_systim4_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_simt_systim4_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex5_cfg_mod = b.addModule("test_test_mutex5_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex5_cfg.zig" },
    });
    test_test_mutex5_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex5_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_perf2_cfg_mod = b.addModule("test_perf2_cfg", .{
        .root_source_file = .{ .path = "test/perf2_cfg.zig" },
    });
    test_perf2_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_perf2_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_mutex6_cfg_mod = b.addModule("test_test_mutex6_cfg", .{
        .root_source_file = .{ .path = "test/test_mutex6_cfg.zig" },
    });
    test_test_mutex6_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_mutex6_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_simt_systim3_cfg_mod = b.addModule("test_simt_systim3_cfg", .{
        .root_source_file = .{ .path = "test/simt_systim3_cfg.zig" },
    });
    test_simt_systim3_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_simt_systim3_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_simt_ovrhdr3_cfg_mod = b.addModule("test_simt_ovrhdr3_cfg", .{
        .root_source_file = .{ .path = "test/simt_ovrhdr3_cfg.zig" },
    });
    test_simt_ovrhdr3_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_simt_ovrhdr3_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const test_test_cpuexc_cfg_mod = b.addModule("test_test_cpuexc_cfg", .{
        .root_source_file = .{ .path = "test/test_cpuexc_cfg.zig" },
    });
    test_test_cpuexc_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    test_test_cpuexc_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    OBJ_ARM_gen_tecsgen_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    OBJ_ARM_gen_tecsgen_cfg_mod.addImport("target_ct11mpcore_gcc_ct11mpcore", target_ct11mpcore_gcc_ct11mpcore_mod);
    library_strerror_mod.addImport("include_t_stddef", include_t_stddef_mod);
    library_errorcode_mod.addImport("include_t_stddef", include_t_stddef_mod);
    const sample_sample3_cfg_mod = b.addModule("sample_sample3_cfg", .{
        .root_source_file = .{ .path = "sample/sample3_cfg.zig" },
    });
    sample_sample3_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    sample_sample3_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const sample_tSample2_cfg_mod = b.addModule("sample_tSample2_cfg", .{
        .root_source_file = .{ .path = "sample/tSample2_cfg.zig" },
    });
    sample_tSample2_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    sample_tSample2_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const sample_sample1_cfg_mod = b.addModule("sample_sample1_cfg", .{
        .root_source_file = .{ .path = "sample/sample1_cfg.zig" },
    });
    sample_sample1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    sample_sample1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const sample_sample3_mod = b.addModule("sample_sample3", .{
        .root_source_file = .{ .path = "sample/sample3.zig" },
    });
    sample_sample3_mod.addImport("include_kernel", include_kernel_mod);
    sample_sample3_mod.addImport("include_t_syslog", include_t_syslog_mod);
    sample_sample3_mod.addImport("include_option", include_option_mod);
    arch_simtimer_sim_timer_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    arch_simtimer_sim_timer_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    const arch_arm_gcc_test_arm_fpu1_cfg_mod = b.addModule("arch_arm_gcc_test_arm_fpu1_cfg", .{
        .root_source_file = .{ .path = "arch/arm_gcc/test/arm_fpu1_cfg.zig" },
    });
    arch_arm_gcc_test_arm_fpu1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    arch_arm_gcc_test_arm_fpu1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    const arch_arm_gcc_test_arm_cpuexc1_cfg_mod = b.addModule("arch_arm_gcc_test_arm_cpuexc1_cfg", .{
        .root_source_file = .{ .path = "arch/arm_gcc/test/arm_cpuexc1_cfg.zig" },
    });
    arch_arm_gcc_test_arm_cpuexc1_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    arch_arm_gcc_test_arm_cpuexc1_cfg_mod.addImport("OBJ_ARM_gen_tecsgen_cfg", OBJ_ARM_gen_tecsgen_cfg_mod);
    arch_arm_gcc_zynq7000_chip_kernel_impl_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_zynq7000_chip_kernel_impl_mod.addImport("arch_arm_gcc_common_mpcore_kernel_impl", arch_arm_gcc_common_mpcore_kernel_impl_mod);
    arch_arm_gcc_zynq7000_chip_kernel_impl_mod.addImport("arch_arm_gcc_common_pl310", arch_arm_gcc_common_pl310_mod);
    arch_arm_gcc_zynq7000_chip_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    arch_arm_gcc_zynq7000_chip_timer_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_zynq7000_chip_timer_mod.addImport("arch_arm_gcc_common_mpcore_timer", arch_arm_gcc_common_mpcore_timer_mod);
    arch_arm_gcc_zynq7000_chip_timer_mod.addImport("arch_arm_gcc_common_mpcore_timer", arch_arm_gcc_common_mpcore_timer_mod);
    arch_arm_gcc_zynq7000_chip_kernel_mod.addImport("arch_arm_gcc_common_core_kernel", arch_arm_gcc_common_core_kernel_mod);
    arch_arm_gcc_rza1_rza1_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_rza1_chip_kernel_impl_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_rza1_chip_kernel_impl_mod.addImport("arch_arm_gcc_common_arm", arch_arm_gcc_common_arm_mod);
    arch_arm_gcc_rza1_chip_kernel_impl_mod.addImport("arch_arm_gcc_common_mpcore_kernel_impl", arch_arm_gcc_common_mpcore_kernel_impl_mod);
    arch_arm_gcc_rza1_chip_kernel_impl_mod.addImport("arch_arm_gcc_common_core_kernel_impl", arch_arm_gcc_common_core_kernel_impl_mod);
    arch_arm_gcc_rza1_chip_kernel_impl_mod.addImport("arch_arm_gcc_common_pl310", arch_arm_gcc_common_pl310_mod);
    arch_arm_gcc_rza1_chip_cfg_mod.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    arch_arm_gcc_rza1_chip_timer_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_rza1_chip_kernel_mod.addImport("arch_arm_gcc_common_core_kernel", arch_arm_gcc_common_core_kernel_mod);
    arch_arm_gcc_common_pl310_mod.addImport("include_option", include_option_mod);
    arch_arm_gcc_common_pl310_mod.addImport("include_sil", include_sil_mod);
    arch_arm_gcc_common_core_kernel_impl_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_common_mpcore_mod.addImport("include_option", include_option_mod);
    arch_arm_gcc_common_mpcore_mod.addImport("include_sil", include_sil_mod);
    const arch_arm_gcc_common_gic_kernel_impl_mod = b.addModule("arch_arm_gcc_common_gic_kernel_impl", .{
        .root_source_file = .{ .path = "arch/arm_gcc/common/gic_kernel_impl.zig" },
    });
    arch_arm_gcc_common_gic_kernel_impl_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_common_mpcore_kernel_impl_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_arm_gcc_common_core_option_mod.addImport("include_kernel", include_kernel_mod);
    arch_arm_gcc_common_mpcore_timer_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);
    arch_tracelog_trace_option_mod.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);

    // マクロ定義の追加
    obj.defineCMacro("TARGET", "\"ct11mpcore_gcc\"");
    obj.defineCMacro("SRCDIR", "\".\"");
    obj.defineCMacro("TECSGENDIR", "\"OBJ-ARM/gen\"");
    obj.defineCMacro("__TARGET_ARCH_ARM", "6");
    obj.defineCMacro("TOPPERS_USE_QEMU", null);

    // インクルードディレクトリの追加
    obj.addIncludePath(.{ .path = "." });
    obj.addIncludePath(.{ .path = "../include" });
    obj.addIncludePath(.{ .path = "../target/ct11mpcore_gcc" });
    obj.addIncludePath(.{ .path = "../arch/arm_gcc/common" });
    obj.addIncludePath(.{ .path = "../arch/gcc" });
    obj.addIncludePath(.{ .path = "../" });
    obj.addIncludePath(.{ .path = "../sample" });
    obj.addIncludePath(.{ .path = "./gen" });
    obj.addIncludePath(.{ .path = "../tecs_kernel" });

    obj.root_module.addImport("kernel_kernel_cfg", kernel_kernel_cfg_mod);
    obj.root_module.addImport("kernel_kernel_impl", kernel_kernel_impl_mod);

    // objsディレクトリにsample1_cfg.oをコピー
    const install_step = b.addInstallFileWithDir(obj.getEmittedBin(), .{ .custom = "OBJ-ARM/objs" }, "sample1_cfg.o");

    // zig buildの一部としてinstall_stepを実行
    b.getInstallStep().dependOn(&install_step.step);
}
