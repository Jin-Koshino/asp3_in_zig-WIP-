///
///  タイマドライバシミュレータのシステムコンフィギュレーション記述
///
const kernel_cfg = @import("../../kernel/kernel_cfg.zig");
usingnamespace kernel_cfg.zig;

////
const CfgData = kernel_cfg.CfgData;
const AINI = kernel_cfg.AINI;
const TA_NULL = t_stddef.TA_NULL;
const ATER = kernel_cfg.ATER;
const CINT = kernel_cfg.CINT;
const TA_ENAINT = zig.TA_ENAINT;
const DINH = kernel_cfg.DINH;
const TOPPERS_SUPPORT_OVRHDR = zig.TOPPERS_SUPPORT_OVRHDR;
////

///
///  タイマドライバ
///
const sim_timer = @import("sim_timer.zig");
usingnamespace sim_timer.ExternDefs;

////
const _kernel_target_timer_initialize = sim_timer._kernel_target_timer_initialize;
const _kernel_target_timer_terminate = sim_timer._kernel_target_timer_terminate;
const _kernel_target_hrt_handler = sim_timer._kernel_target_ovrtimer_handler;
const _kernel_target_ovrtimer_handler = sim_timer._kernel_target_ovrtimer_handler;
////

///
///  システムコンフィギュレーション記述
///
pub fn configuration(comptime cfg: *CfgData) void {
    // 高分解能タイマ，オーバランタイマ共通
    cfg.ATT_INI(AINI(TA_NULL, 0, _kernel_target_timer_initialize));
    cfg.ATT_TER(ATER(TA_NULL, 0, _kernel_target_timer_terminate));

    // 高分解能タイマドライバ
    cfg.CFG_INT(sim_timer.hrt.INTNO_HRT, CINT(TA_ENAINT | sim_timer.hrt.INTATR_HRT, sim_timer.hrt.INTPRI_HRT));
    cfg.DEF_INH(sim_timer.hrt.INHNO_HRT, DINH(TA_NULL, _kernel_target_hrt_handler));

    // オーバランタイマドライバ
    if (TOPPERS_SUPPORT_OVRHDR) {
        cfg.CFG_INT(sim_timer.ovrtimer.INTNO_OVRTIMER, CINT(TA_ENAINT | sim_timer.ovrtimer.INTATR_OVRTIMER, sim_timer.ovrtimer.INTPRI_OVRTIMER));
        cfg.DEF_INH(sim_timer.ovrtimer.INHNO_OVRTIMER, DINH(TA_NULL, _kernel_target_ovrtimer_handler));
    }
}
