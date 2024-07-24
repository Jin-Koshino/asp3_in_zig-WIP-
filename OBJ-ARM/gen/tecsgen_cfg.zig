// gen/tecsgen_cfg.zig

const kernel_cfg = @import("../../kernel/kernel_cfg.zig");

const c = @cImport({
    @cDefine("UINT_C(val)", "val");
    @cInclude("tTask_tecsgen.h");
    @cInclude("tISR_tecsgen.h");
    @cInclude("tInitializeRoutine_tecsgen.h");
    @cInclude("tTerminateRoutine_tecsgen.h");
});

const CTSK = kernel_cfg.CTSK;
const CSEM = kernel_cfg.CSEM;
const CINT = kernel_cfg.CINT;
const CISR = kernel_cfg.CISR;
const AINI = kernel_cfg.AINI;
const ATER = kernel_cfg.ATER;
const tTask_start = c.tTask_start;
const ct11mpcore = @import("../../target/ct11mpcore_gcc/ct11mpcore.zig");
const EB_IRQNO_UART0 = ct11mpcore.EB_IRQNO_UART0;
const tISR_start = c.tISR_start;
const tInitializeRoutine_start = c.tInitializeRoutine_start;
const tTerminateRoutine_start = c.tTerminateRoutine_start;
const zig = kernel_cfg.zig;
const t_stddef = zig.t_stddef;
const TA_ACT = zig.TA_ACT;
const TA_NULL = t_stddef.TA_NULL;
const CfgData = kernel_cfg.CfgData;

const tTask_INIB = c.tTask_INIB;
const p_tTask_INIB_tab = kernel_cfg.importSymbol([100]tTask_INIB, "tTask_INIB_tab");
const tISR_INIB = c.tISR_INIB;
const p_tISR_INIB_tab = kernel_cfg.importSymbol([100]tISR_INIB, "tISR_INIB_tab");
const tTerminateRoutine_INIB = c.tTerminateRoutine_INIB;
const p_tTerminateRoutine_INIB_tab = kernel_cfg.importSymbol([100]tTerminateRoutine_INIB, "tTerminateRoutine_INIB_tab");

pub fn configuration(comptime cfg: *CfgData) void {
    cfg.CRE_TSK("TSKID_tTask_LogTask_Task", CTSK(TA_ACT, &p_tTask_INIB_tab[0], tTask_start, 3, 4096, null));
    cfg.CRE_SEM("SEMID_tSemaphore_SerialPort1_ReceiveSemaphore", CSEM(TA_NULL, 0, 1));
    cfg.CRE_SEM("SEMID_tSemaphore_SerialPort1_SendSemaphore", CSEM(TA_NULL, 1, 1));
    cfg.CFG_INT(EB_IRQNO_UART0, CINT(TA_NULL, -2));
    cfg.CRE_ISR("ISRID_tISR_SIOPortTarget1_ISRInstance", CISR(TA_NULL, &p_tISR_INIB_tab[0], EB_IRQNO_UART0, tISR_start, 1));
    cfg.ATT_INI(AINI(TA_NULL, null, tInitializeRoutine_start));
    cfg.ATT_TER(ATER(TA_NULL, &p_tTerminateRoutine_INIB_tab[0], tTerminateRoutine_start));
    cfg.ATT_TER(ATER(TA_NULL, &p_tTerminateRoutine_INIB_tab[1], tTerminateRoutine_start));
}
