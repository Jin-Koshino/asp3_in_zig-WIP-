///
///  サンプルプログラム(1)のシステムコンフィギュレーション記述
///
const kernel_cfg = @import("kernel_cfg");

////
const zig = kernel_cfg.zig;
const t_stddef = zig.t_stddef;

const option = kernel_cfg.option;
const CfgData = kernel_cfg.CfgData;
const GenCfgData = kernel_cfg.GenCfgData;
const CTSK = kernel_cfg.CTSK;
const CCYC = kernel_cfg.CCYC;
const CALM = kernel_cfg.CALM;
const DOVR = kernel_cfg.DOVR;
const CINT = kernel_cfg.CINT;
const CISR = kernel_cfg.CISR;
const DEXC = kernel_cfg.DEXC;
const NFY_TMEHDR = kernel_cfg.NFY_TMEHDR;
const TA_NULL = t_stddef.TA_NULL;
const TA_ACT = zig.TA_ACT;
const target = kernel_cfg.target;
////

///
///  TECSが生成するコンフィギュレーション記述
///
const tecs = @import("../OBJ-ARM/gen/tecsgen_cfg.zig");

///
///  C言語ヘッダファイルの取り込み
///
const cimport = @cImport({
    @cDefine("UINT_C(val)", "val");
    @cInclude("sample1.h");
});

////
const task = cimport.task;
const main_task = cimport.main_task;
const exc_task = cimport.exc_task;
const intno1_isr = cimport.intno1_isr;
const cpuexc_handler = cimport.cpuexc_handler;
const EXC_PRIORITY = cimport.EXC_PRIORITY;
const MAIN_PRIORITY = cimport.MAIN_PRIORITY;
const MID_PRIORITY = cimport.MID_PRIORITY;
const STACK_SIZE = cimport.STACK_SIZE;
const cyclic_handler = cimport.cyclic_handler;
const alarm_handler = cimport.alarm_handler;
const overrun_handler = cimport.overrun_handler;
////

///
///  システムコンフィギュレーション記述本体
///
fn configuration(comptime cfg: *CfgData) void {
    tecs.configuration(cfg);
    cfg.CRE_TSK("TASK1", CTSK(TA_NULL, 1, task, MID_PRIORITY, STACK_SIZE, null));
    //  代案
    //  cfg.CRE_TSK("TASK1", .{ .exinf = @castToExinf(1),
    //                          .task = task,
    //                          .itskpri = MID_PRIORITY,
    //                          .stksz = STACK_SIZE, });
    cfg.CRE_TSK("TASK2", CTSK(TA_NULL, 2, task, MID_PRIORITY, STACK_SIZE, null));
    cfg.CRE_TSK("TASK3", CTSK(TA_NULL, 3, task, MID_PRIORITY, STACK_SIZE, null));
    cfg.CRE_TSK("MAIN_TASK", CTSK(TA_ACT, 0, main_task, MAIN_PRIORITY, STACK_SIZE, null));
    cfg.CRE_TSK("EXC_TASK", CTSK(TA_NULL, 0, exc_task, EXC_PRIORITY, STACK_SIZE, null));
    cfg.CRE_CYC("CYCHDR1", CCYC(TA_NULL, NFY_TMEHDR(0, cyclic_handler), 2_000_000, 0));
    //    cfg.CRE_CYC("CYCHDR1", CCYC(TA_NULL,
    //                                NFYINFO(.{ TNFY_ACTTSK, "TASK1" }, cfg),
    //                                2_000_000, 0));
    cfg.CRE_ALM("ALMHDR1", CALM(TA_NULL, NFY_TMEHDR(0, alarm_handler)));
    if (zig.TOPPERS_SUPPORT_OVRHDR) {
        cfg.DEF_OVR(DOVR(TA_NULL, overrun_handler));
    }
    if (@hasDecl(option.target._test, "INTNO1")) {
        cfg.CFG_INT(option.target._test.INTNO1, CINT(option.target._test.INTNO1_INTATR, option.target._test.INTNO1_INTPRI));
        cfg.CRE_ISR("INTNO1_ISR", CISR(TA_NULL, 0, option.target._test.INTNO1, intno1_isr, 1));
    }
    if (@hasDecl(option.target._test, "CPUEXC1")) {
        cfg.DEF_EXC(option.target._test.CPUEXC1, DEXC(TA_NULL, cpuexc_handler));
    }
}

//
//  静的APIの読み込みとコンフィギュレーションデータの生成
//
//  以下は変更する必要がない．
//
//  genConfigにvoid型のパラメータを渡すのは，Zigコンパイラの不具合の回
//  避のため（これがないと，genConfigが2回実行される）．
//
//  genConfigをpubにするのは，BIND_CFGに対応するため．
//
pub fn genConfig(comptime dummy: void) type {
    comptime var cfg = CfgData{};
    target.configuration(&cfg);
    configuration(&cfg);
    _ = dummy;
    return GenCfgData(&cfg);
}
export const _ = if (@hasDecl(@This(), "BIND_CFG"))
{} else genConfig({}){};

///
///  リンクエラーを防ぐための関数（エラーになる原因は不明）
///
export fn __aeabi_unwind_cpp_pr0() void {}
