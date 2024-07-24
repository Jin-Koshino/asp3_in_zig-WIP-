///
///  システムコンフィギュレーション記述のターゲット依存部（CT11MPCore用）
///
const kernel_cfg = @import("../../kernel/kernel_cfg.zig");
const zig = kernel_cfg.zig;
////
const t_stddef = zig.t_stddef;

const option = kernel_cfg.option;
const CfgData = kernel_cfg.CfgData;
const AINI = kernel_cfg.AINI;
const ATER = kernel_cfg.ATER;
const CINT = kernel_cfg.CINT;
const DINH = kernel_cfg.DINH;
const TA_NULL = t_stddef.TA_NULL;
const TA_ENAINT = zig.TA_ENAINT;
const TOPPERS_SUPPORT_OVRHDR = zig.TOPPERS_SUPPORT_OVRHDR;
////

///
///  タイマドライバ
///
const target_timer = @import("target_timer.zig");
///usingnamespace target_timer.ExternDefs;

////
const _kernel_target_hrt_initialize = target_timer.ExternDefs._kernel_target_hrt_initialize;
const _kernel_target_hrt_terminate = target_timer.ExternDefs._kernel_target_hrt_terminate;
const _kernel_target_hrt_handler = target_timer.ExternDefs._kernel_target_hrt_handler;
const _kernel_target_ovrtimer_initialize = target_timer.ExternDefs._kernel_target_ovrtimer_initialize;
const _kernel_target_ovrtimer_terminate = target_timer.ExternDefs._kernel_target_ovrtimer_terminate;
const _kernel_target_ovrtimer_handler = target_timer.ExternDefs._kernel_target_ovrtimer_handler;
////

///
///  システムコンフィギュレーション記述
///
pub fn configuration(comptime cfg: *CfgData) void {
    // 高分解能タイマドライバ
    cfg.ATT_INI(AINI(TA_NULL, 0, _kernel_target_hrt_initialize));
    cfg.ATT_TER(ATER(TA_NULL, 0, _kernel_target_hrt_terminate));

    cfg.CFG_INT(target_timer.hrt.INTNO_HRT, CINT(TA_ENAINT | target_timer.hrt.INTATR_HRT, target_timer.hrt.INTPRI_HRT));
    cfg.DEF_INH(target_timer.hrt.INHNO_HRT, DINH(TA_NULL, _kernel_target_hrt_handler));

    // オーバランタイマドライバ
    if (TOPPERS_SUPPORT_OVRHDR) {
        cfg.ATT_INI(AINI(TA_NULL, 0, _kernel_target_ovrtimer_initialize));
        cfg.ATT_TER(ATER(TA_NULL, 0, _kernel_target_ovrtimer_terminate));

        cfg.CFG_INT(target_timer.ovrtimer.INTNO_OVRTIMER, CINT(TA_ENAINT | target_timer.ovrtimer.INTATR_OVRTIMER, target_timer.ovrtimer.INTPRI_OVRTIMER));
        cfg.DEF_INH(target_timer.ovrtimer.INHNO_OVRTIMER, DINH(TA_NULL, _kernel_target_ovrtimer_handler));
    }
}
