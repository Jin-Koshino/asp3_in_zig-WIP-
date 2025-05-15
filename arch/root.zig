// arm_gcc/common
pub const arm = @import("arm_gcc/common/arm.zig");
pub const core_kernel = @import("arm_gcc/common/core_kernel.zig");
pub const core_kernel_impl = @import("arm_gcc/common/core_kernel_impl.zig");
pub const core_option = @import("arm_gcc/common/core_option.zig");
pub const core_sil = @import("arm_gcc/common/core_sil.zig");
pub const gic_kernel_impl = @import("arm_gcc/common/gic_kernel_impl.zig");
pub const mpcore = @import("arm_gcc/common/mpcore.zig");
pub const mpcore_kernel_impl = @import("arm_gcc/common/mpcore_kernel_impl.zig");
pub const mpcore_timer = @import("arm_gcc/common/mpcore_timer.zig");
pub const pl310 = @import("arm_gcc/common/pl310.zig");

// // arm_gcc/rza1
// pub const rza1 = @import("arm_gcc/rza1/rza1.zig");
// pub const rza1_chip_cfg = @import("arm_gcc/rza1/chip_cfg.zig");
// pub const rza1_chip_kernel = @import("arm_gcc/rza1/chip_kernel.zig");
// pub const rza1_chip_kernel_impl = @import("arm_gcc/rza1/chip_kernel_impl.zig");
// pub const rza1_chip_timer = @import("arm_gcc/rza1/chip_timer.zig");
// pub const rza1_chip_stddef = @import("arm_gcc/rza1/chip_stddef.zig");

// // arm_gcc/zynq7000
// pub const zynq7000 = @import("arm_gcc/zynq7000/zynq7000.zig");
// pub const zynq7000_chip_cfg = @import("arm_gcc/zynq7000/chip_cfg.zig");
// pub const zynq7000_chip_kernel = @import("arm_gcc/zynq7000/chip_kernel.zig");
// pub const zynq7000_chip_kernel_impl = @import("arm_gcc/zynq7000/chip_kernel_impl.zig");
// pub const zynq7000_chip_timer = @import("arm_gcc/zynq7000/chip_timer.zig");
// pub const zynq7000_chip_stddef = @import("arm_gcc/zynq7000/chip_stddef.zig");

// simtimer
pub const sim_timer = @import("simtimer/sim_timer.zig");
pub const sim_timer_cfg = @import("simtimer/sim_timer_cfg.zig");

// tracelog
pub const trace_option = @import("tracelog/trace_option.zig");
