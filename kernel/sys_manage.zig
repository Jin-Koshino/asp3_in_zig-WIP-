///
///  TOPPERS/ASP Kernel
///      Toyohashi Open Platform for Embedded Real-Time Systems/
///      Advanced Standard Profile Kernel
///
///  Copyright (C) 2000-2003 by Embedded and Real-Time Systems Laboratory
///                                 Toyohashi Univ. of Technology, JAPAN
///  Copyright (C) 2005-2020 by Embedded and Real-Time Systems Laboratory
///                 Graduate School of Informatics, Nagoya Univ., JAPAN
///
///  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
///  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
///  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
///  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
///      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
///      スコード中に含まれていること．
///  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
///      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
///      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
///      の無保証規定を掲載すること．
///  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
///      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
///      と．
///    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
///        作権表示，この利用条件および下記の無保証規定を掲載すること．
///    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
///        報告すること．
///  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
///      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
///      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
///      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
///      免責すること．
///
///  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
///  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
///  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
///  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
///  の責任を負わない．
///
///  $Id$
///
///
///  システム状態管理機能
///
const kernel_impl = @import("kernel_impl.zig");
///usingnamespace task;
const task = kernel_impl.task;
///usingnamespace check;
const check = kernel_impl.check;

////
const zig = kernel_impl.zig;
const t_stddef = zig.t_stddef;

const ATR = t_stddef.ATR;
const OVRHDR = zig.OVRHDR;
const TOPPERS_SUPPORT_OVRHDR = zig.TOPPERS_SUPPORT_OVRHDR;

const target_timer = kernel_impl.target_timer;
const ID = t_stddef.ID;
const PRCTIM = t_stddef.PRCTIM;
const ItronError = t_stddef.ItronError;
const TCB = task.TCB;
const traceLog = kernel_impl.traceLog;
const checkNotSupported = check.checkNotSupported;
const checkContextUnlock = check.checkContextUnlock;
const checkObjectState = check.checkObjectState;
const cfg = check.cfg;
const TSK_SELF = zig.TSK_SELF;
const target_impl = kernel_impl.target_impl;
const checkAndGetTCB = task.checkAndGetTCB;
const checkParameter = check.checkParameter;
const TMAX_OVRTIM = zig.TMAX_OVRTIM;
const T_ROVR = zig.T_ROVR;
const checkContextTaskUnlock = check.checkContextTaskUnlock;
const TOVR_STP = zig.TOVR_STP;
const TOVR_STA = zig.TOVR_STA;
const assert = t_stddef.assert;
const getTskIdFromTCB = task.getTskIdFromTCB;
const T_DOVR = zig.T_DOVR;
const checkValidAtr = check.checkValidAtr;
const TA_NULL = t_stddef.TA_NULL;
const exportCheck = kernel_impl.exportCheck;
const PRI = t_stddef.PRI;
const TaskPrio = task.TaskPrio;
const TPRI_SELF = zig.TPRI_SELF;
const validTaskPri = task.validTaskPri;
const internalTaskPrio = task.internalTaskPrio;
const rotate_ready_queue = task.rotate_ready_queue;
const requestTaskDispatch = task.requestTaskDispatch;
const TSK_NONE = zig.TPRI_SELF;
const getTCBFromQueue = task.getTCBFromQueue;

const TIPM_ENAALL = zig.TIPM_ENAALL;
const set_dspflg = task.set_dspflg;
const task_terminate = task.task_terminate;
const taskDispatch = task.taskDispatch;
const startup = kernel_impl.startup;
////

///
///  タスクの優先順位の回転［NGKI3548］
///
pub fn rot_rdq(tskpri: PRI) ItronError!void {
    var prio: TaskPrio = undefined;

    traceLog("rotRdqEnter", .{tskpri});
    errdefer |err| traceLog("rotRdqLeave", .{err});
    try checkContextUnlock(); //［NGKI2684］
    if (tskpri == TPRI_SELF and !target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext()) {
        prio = task.p_runtsk.?.bprio; //［NGKI2689］
    } else {
        try checkParameter(validTaskPri(tskpri)); //［NGKI2685］
        prio = internalTaskPrio(tskpri);
    }
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        rotate_ready_queue(prio);
        requestTaskDispatch();
    }
    traceLog("rotRdqLeave", .{null});
}

///
///  実行状態のタスクIDの参照［NGKI3550］
///
pub fn get_tid(p_tskid: *ID) ItronError!void {
    traceLog("getTidEnter", .{p_tskid});
    errdefer |err| traceLog("getTidLeave", .{ err, p_tskid });
    try checkContextUnlock(); //［NGKI2707］

    if (task.p_runtsk) |p_tcb| {
        p_tskid.* = getTskIdFromTCB(p_tcb); //［NGKI2709］
    } else {
        p_tskid.* = TSK_NONE; //［NGKI2710］
    }
    traceLog("getTidLeave", .{ null, p_tskid });
}

///
///  実行できるタスクの数の参照［NGKI3623］
///
pub fn get_lod(tskpri: PRI, p_load: *c_uint) ItronError!void {
    var prio: TaskPrio = undefined;
    var load: c_uint = 0;

    traceLog("getLodEnter", .{ tskpri, p_load });
    errdefer |err| traceLog("getLodLeave", .{ err, p_load });
    try checkContextTaskUnlock(); //［NGKI3624］［NGKI3625］
    if (tskpri == TPRI_SELF) {
        prio = task.p_runtsk.?.bprio; //［NGKI3631］
    } else {
        try checkParameter(validTaskPri(tskpri)); //［NGKI3626］
        prio = internalTaskPrio(tskpri);
    }
    var p_queue = &task.ready_queue[prio];
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        var p_entry = p_queue.p_next;
        while (p_entry != p_queue) : (p_entry = p_entry.p_next) {
            load += 1;
        }
        p_load.* = load;
    }
    traceLog("getLodLeave", .{ null, p_load });
}

///
///  指定した優先順位のタスクIDの参照［NGKI3641］
///
pub fn get_nth(tskpri: PRI, nth: c_uint, p_tskid: *ID) ItronError!void {
    var prio: TaskPrio = undefined;

    traceLog("getNthEnter", .{ tskpri, nth, p_tskid });
    errdefer |err| traceLog("getNthLeave", .{ err, p_tskid });
    try checkContextTaskUnlock(); //［NGKI3642］［NGKI3643］
    if (tskpri == TPRI_SELF) {
        prio = task.p_runtsk.?.bprio; //［NGKI3650］
    } else {
        try checkParameter(validTaskPri(tskpri)); //［NGKI3644］
        prio = internalTaskPrio(tskpri);
    }
    var p_queue = &task.ready_queue[prio];
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        var count: c_uint = 0;
        var p_entry = p_queue.p_next;
        while (p_entry != p_queue) : (p_entry = p_entry.p_next) {
            if (count == nth) {
                p_tskid.* = getTskIdFromTCB(getTCBFromQueue(p_entry));
                break;
            }
            count += 1;
        } else {
            p_tskid.* = TSK_NONE;
        }
    }
    traceLog("getNthLeave", .{ null, p_tskid });
}

///
///  CPUロック状態への遷移［NGKI3538］
///
pub fn loc_cpu() ItronError!void {
    traceLog("locCpuEnter", .{});
    if (!target_impl.mpcore_kernel_impl.core_kernel_impl.senseLock()) { //［NGKI2731］
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu(); //［NGKI2730］
    }
    traceLog("locCpuLeave", .{null});
}

///
///  CPUロック状態の解除［NGKI3539］
///
///  CPUロック中は，ディスパッチが必要となるサービスコールを呼び出すこ
///  とはできないため，CPUロック状態の解除時にディスパッチャを起動する
///  必要はない．
///
pub fn unl_cpu() ItronError!void {
    traceLog("unlCpuEnter", .{});
    if (target_impl.mpcore_kernel_impl.core_kernel_impl.senseLock()) { //［NGKI2738］
        target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu(); //［NGKI2737］
    }
    traceLog("unlCpuLeave", .{null});
}

///
///  ディスパッチの禁止［NGKI2740］
///
pub fn dis_dsp() ItronError!void {
    traceLog("disDspEnter", .{});
    errdefer |err| traceLog("disDspLeave", .{err});
    try checkContextTaskUnlock(); //［NGKI2741］［NGKI2742］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        task.enadsp = false;
        task.dspflg = false;
    }
    traceLog("disDspLeave", .{null});
}

///
///  ディスパッチの許可［NGKI2746］
///
pub fn ena_dsp() ItronError!void {
    traceLog("enaDspEnter", .{});
    errdefer |err| traceLog("enaDspLeave", .{err});
    try checkContextTaskUnlock(); //［NGKI2747］［NGKI2748］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        task.enadsp = true;
        if (target_impl.mpcore_kernel_impl.gic_kernel_impl.getIpm() == TIPM_ENAALL) {
            set_dspflg();
            if (task.p_runtsk.?.flags.raster and task.p_runtsk.?.flags.enater) {
                if (TOPPERS_SUPPORT_OVRHDR) {
                    if (task.p_runtsk.?.flags.staovr) {
                        _ = target_timer.ovrtimer.stop();
                    }
                }
                task_terminate(task.p_runtsk.?);
                target_impl.mpcore_kernel_impl.core_kernel_impl.exitAndDispatch();
            } else {
                taskDispatch();
            }
        }
    }
    traceLog("enaDspLeave", .{null});
}

///
///  コンテキストの参照［NGKI2752］
///
pub fn sns_ctx() bool {
    traceLog("snsCtxEnter", .{});
    var state = target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext();
    traceLog("snsCtxLeave", .{state});
    return state;
}

///
///  CPUロック状態の参照［NGKI2754］
///
pub fn sns_loc() bool {
    traceLog("snsLocEnter", .{});
    var state = target_impl.mpcore_kernel_impl.core_kernel_impl.senseLock();
    traceLog("snsLocLeave", .{state});
    return state;
}

///
///  ディスパッチ禁止状態の参照［NGKI2756］
///
pub fn sns_dsp() bool {
    traceLog("snsDspEnter", .{});
    var state = !task.enadsp;
    traceLog("snsDspLeave", .{state});
    return state;
}

///
///  ディスパッチ保留状態の参照［NGKI2758］
///
pub fn sns_dpn() bool {
    traceLog("snsDpnEnter", .{});
    var state = target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext() or target_impl.mpcore_kernel_impl.core_kernel_impl.senseLock() or !task.dspflg;
    traceLog("snsDpnLeave", .{state});
    return state;
}

///
///  カーネル非動作状態の参照［NGKI2760］
///
pub fn sns_ker() bool {
    traceLog("snsKerEnter", .{});
    var state = !startup.kerflg;
    traceLog("snsKerLeave", .{state});
    return state;
}
