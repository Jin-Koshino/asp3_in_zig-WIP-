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
///  タスク付属同期機能
///
const kernel_impl = @import("kernel_impl.zig");
///usingnamespace task;
const task = kernel_impl.task;
///usingnamespace wait;
const wait = kernel_impl.wait;
///usingnamespace time_event;
const time_event = kernel_impl.time_event;
///usingnamespace check;
const check = kernel_impl.check;

////
const zig = kernel_impl.zig;
const t_stddef = zig.t_stddef;

const ATR = t_stddef.ATR;
const checkWobjIniB = check.checkWobjIniB;
const queue = kernel_impl.queue;
const checkWobjCB = wait.checkWobjCB;
const WINFO = wait.WINFO;
const checkWinfoWobj = wait.checkWinfoWobj;
const ID = t_stddef.ID;
const TMIN_DTQID = kernel_impl.TMIN_DTQID;
const cfg = kernel_impl.cfg;
const ItronError = t_stddef.ItronError;
const checkId = check.checkId;
const getTCBFromQueue = task.getTCBFromQueue;
const wait_complete = wait.wait_complete;
const traceLog = kernel_impl.traceLog;
const checkDispatch = check.checkDispatch;
const target_impl = kernel_impl.target_impl;

const taskDispatch = task.taskDispatch;
const wobj_make_wait = wait.wobj_make_wait;
const TS_WAITING_SDTQ = task.TS_WAITING_SDTQ;
const checkContextUnlock = check.checkContextUnlock;
const requestTaskDispatch = task.requestTaskDispatch;
const TMO = t_stddef.TMO;
const checkParameter = check.checkParameter;
const validTimeout = check.validTimeout;
const TMO_POL = t_stddef.TMO_POL;
const TMEVTB = time_event.TMEVTB;
const wobj_make_wait_tmout = wait.wobj_make_wait_tmout;
const checkIllegalUse = check.checkIllegalUse;
const wobj_make_rwait = wait.wobj_make_rwait;
const TS_WAITING_RDTQ = task.TS_WAITING_RDTQ;
const checkContextTaskUnlock = check.checkContextTaskUnlock;
const wobj_make_rwait_tmout = wait.wobj_make_rwait_tmout;
const init_wait_queue = wait.init_wait_queue;
const T_RDTQ = zig.T_RDTQ;
const wait_tskid = wait.wait_tskid;
const T_CDTQ = zig.T_CDTQ;
const checkValidAtr = check.checkValidAtr;
const TA_TPRI = zig.TA_TPRI;
const checkNotSupported = check.checkNotSupported;
const option = kernel_impl.option;
const TCB = task.TCB;
const T_RTSK = zig.T_RTSK;
const TS_WAITING_MASK = task.TS_WAITING_MASK;
const TS_WAITING_SLP = task.TS_WAITING_SLP;
const TTW_SLP = zig.TTW_SLP;
const TS_WAITING_DLY = task.TS_WAITING_DLY;
const TTW_DLY = zig.TTW_DLY;
const TS_WAITING_SEM = task.TS_WAITING_SEM;
const TTW_SEM = zig.TTW_SEM;
const semaphore = kernel_impl.semaphore;
const TS_WAITING_FLG = task.TS_WAITING_FLG;
const TTW_FLG = zig.TTW_FLG;
const eventflag = kernel_impl.eventflag;
const TTW_SDTQ = zig.TTW_SDTQ;
const dataqueue = kernel_impl.dataqueue;
const TTW_RDTQ = zig.TTW_RDTQ;
const TS_WAITING_SPDQ = task.TS_WAITING_SPDQ;
const TTW_SPDQ = zig.TTW_SPDQ;
const pridataq = kernel_impl.pridataq;
const TS_WAITING_RPDQ = task.TS_WAITING_RPDQ;
const TTW_RPDQ = zig.TTW_RPDQ;
const TS_WAITING_MTX = task.TS_WAITING_MTX;
const mutex = kernel_impl.mutex;
const TS_WAITING_MPF = task.TS_WAITING_MPF;
const TTW_MPF = zig.TTW_MPF;
const mempfix = kernel_impl.mempfix;
const TSK_SELF = zig.TSK_SELF;
const checkAndGetTCB = task.checkAndGetTCB;
const isDormant = task.isDormant;
const TTS_DMT = zig.TTS_DMT;
const isWaiting = task.isWaiting;
const isSuspended = task.isSuspended;
const TTS_WAS = zig.TTS_WAS;
const TTS_WAI = zig.TTS_WAI;
const tmevt_lefttim = time_event.tmevt_lefttim;
const TMO_FEVR = t_stddef.TMO_FEVR;
const TTS_SUS = zig.TTS_SUS;
const TTS_RUN = zig.TTS_RUN;
const TTS_RDY = zig.TTS_RDY;
const externalTaskPrio = task.externalTaskPrio;
const make_wait = wait.make_wait;
const make_wait_tmout = wait.make_wait_tmout;
const isWaitingSlp = task.isWaitingSlp;
const TMAX_WUPCNT = zig.TMAX_WUPCNT;
const wait_dequeue_wobj = wait.wait_dequeue_wobj;
const wait_dequeue_tmevtb = wait.wait_dequeue_tmevtb;
const make_non_wait = wait.make_non_wait;
const isRunnable = task.isRunnable;
const TS_SUSPENDED = task.TS_SUSPENDED;
const make_non_runnable = task.make_non_runnable;
const TS_RUNNABLE = task.TS_RUNNABLE;
const make_runnable = task.make_runnable;
const RELTIM = t_stddef.RELTIM;
const validRelativeTime = check.validRelativeTime;
const wait_tmout_ok = wait.wait_tmout_ok;
const tmevtb_enqueue_reltim = time_event.tmevtb_enqueue_reltim;
////

///
///  起床待ち［NGKI1252］
///
pub fn slp_tsk() ItronError!void {
    var winfo: WINFO = undefined;

    traceLog("slpTskEnter", .{});
    errdefer |err| traceLog("slpTskLeave", .{err});
    try checkDispatch(); //［NGKI1254］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpuDsp();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpuDsp();

        var p_selftsk = task.p_runtsk.?;
        if (p_selftsk.flags.raster) { //［NGKI3455］
            return ItronError.TerminationRequestRaised;
        } else if (p_selftsk.flags.wupque > 0) {
            p_selftsk.flags.wupque -= 1; //［NGKI1259］
        } else {
            make_wait(TS_WAITING_SLP, &winfo); //［NGKI1260］
            traceLog("taskStateChange", .{p_selftsk});
            target_impl.mpcore_kernel_impl.core_kernel_impl.dispatch();
            if (winfo.werror) |werror| {
                return werror.*;
            }
        }
    }
    traceLog("slpTskLeave", .{null});
}

///
///  起床待ち（タイムアウトあり）［NGKI1253］
///
pub fn tslp_tsk(tmout: TMO) ItronError!void {
    var winfo: WINFO = undefined;
    var tmevtb: TMEVTB = undefined;

    traceLog("tSlpTskEnter", .{tmout});
    errdefer |err| traceLog("tSlpTskLeave", .{err});
    try checkDispatch(); //［NGKI1254］
    try checkParameter(validTimeout(tmout)); //［NGKI1256］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpuDsp();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpuDsp();

        var p_selftsk = task.p_runtsk.?;
        if (p_selftsk.flags.raster) { //［NGKI3455］
            return ItronError.TerminationRequestRaised;
        } else if (p_selftsk.flags.wupque > 0) {
            p_selftsk.flags.wupque -= 1; //［NGKI1259］
        } else if (tmout == TMO_POL) {
            return ItronError.TimeoutError; //［NGKI1257］
        } else { //［NGKI1260］
            make_wait_tmout(TS_WAITING_SLP, &winfo, &tmevtb, tmout);
            traceLog("taskStateChange", .{p_selftsk});
            target_impl.mpcore_kernel_impl.core_kernel_impl.dispatch();
            if (winfo.werror) |werror| {
                return werror.*;
            }
        }
    }
    traceLog("tSlpTskLeave", .{null});
}

///
///  タスクの起床［NGKI3531］
///
pub fn wup_tsk(tskid: ID) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("wupTskEnter", .{tskid});
    errdefer |err| traceLog("wupTskLeave", .{err});
    try checkContextUnlock(); //［NGKI1265］
    if (tskid == TSK_SELF and !target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext()) {
        p_tcb = task.p_runtsk.?; //［NGKI1275］
    } else {
        p_tcb = try checkAndGetTCB(tskid); //［NGKI1267］
    }
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (isDormant(p_tcb.tstat)) { //［NGKI1270］
            return ItronError.ObjectStateError;
        } else if (isWaitingSlp(p_tcb.tstat)) {
            wait_complete(p_tcb); //［NGKI1271］
            requestTaskDispatch();
        } else if (p_tcb.flags.wupque < TMAX_WUPCNT) {
            p_tcb.flags.wupque += 1; //［NGKI1273］
        } else {
            return ItronError.QueueingOverflow; //［NGKI1274］
        }
    }
    traceLog("wupTskLeave", .{null});
}

///
///  タスク起床要求のキャンセル［NGKI1276］
///
pub fn can_wup(tskid: ID) ItronError!c_uint {
    var p_tcb: *TCB = undefined;
    var retval: c_uint = undefined;

    traceLog("canWupEnter", .{tskid});
    errdefer |err| traceLog("canWupLeave", .{err});
    try checkContextTaskUnlock(); //［NGKI1277］［NGKI1278］
    if (tskid == TSK_SELF) {
        p_tcb = task.p_runtsk.?; //［NGKI1285］
    } else {
        p_tcb = try checkAndGetTCB(tskid); //［NGKI1280］
    }
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (isDormant(p_tcb.tstat)) { //［NGKI1283］
            return ItronError.ObjectStateError;
        } else {
            retval = p_tcb.flags.wupque; //［NGKI1284］
            p_tcb.flags.wupque = 0; //［NGKI1284］
        }
    }
    traceLog("canWupLeave", .{retval});
    return retval;
}

///
///  待ち状態の強制解除［NGKI3532］
///
pub fn rel_wai(tskid: ID) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("relWaiEnter", .{tskid});
    errdefer |err| traceLog("relWaiLeave", .{err});
    try checkContextUnlock(); //［NGKI1290］
    p_tcb = try checkAndGetTCB(tskid); //［NGKI1292］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (!isWaiting(p_tcb.tstat)) { //［NGKI1295］
            return ItronError.ObjectStateError;
        } else {
            wait_dequeue_wobj(p_tcb); //［NGKI1296］
            wait_dequeue_tmevtb(p_tcb); //［NGKI1297］
            p_tcb.p_winfo.* = WINFO{ .werror = &ItronError.ReleasedFromWaiting };
            make_non_wait(p_tcb);
            requestTaskDispatch();
        }
    }
    traceLog("relWaiLeave", .{null});
}

///
///  強制待ち状態への移行［NGKI1298］
///
pub fn sus_tsk(tskid: ID) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("susTskEnter", .{tskid});
    errdefer |err| traceLog("susTskLeave", .{err});
    try checkContextTaskUnlock(); //［NGKI1299］［NGKI1300］
    if (tskid == TSK_SELF) {
        p_tcb = task.p_runtsk.?; //［NGKI1310］
    } else {
        p_tcb = try checkAndGetTCB(tskid); //［NGKI1302］
    }
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_tcb == task.p_runtsk and !task.dspflg) { //［NGKI1311］［NGKI3604］
            return ItronError.ContextError;
        } else if (isDormant(p_tcb.tstat)) { //［NGKI1305］
            return ItronError.ObjectStateError;
        } else if (p_tcb.flags.raster) { //［NGKI3605］
            return ItronError.TerminationRequestRaised;
        } else if (isRunnable(p_tcb.tstat)) {
            // 実行できる状態から強制待ち状態への遷移［NGKI1307］
            p_tcb.tstat = TS_SUSPENDED;
            traceLog("taskStateChange", .{p_tcb});
            make_non_runnable(p_tcb);
            taskDispatch();
        } else if (isSuspended(p_tcb.tstat)) { //［NGKI1306］
            return ItronError.QueueingOverflow;
        } else {
            // 待ち状態から二重待ち状態への遷移［NGKI1308］
            p_tcb.tstat |= @as(u8, TS_SUSPENDED);
            traceLog("taskStateChange", .{p_tcb});
        }
    }
    traceLog("susTskLeave", .{null});
}

///
///  強制待ち状態からの再開［NGKI1312］
///
pub fn rsm_tsk(tskid: ID) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("rsmTskEnter", .{tskid});
    errdefer |err| traceLog("rsmTskLeave", .{err});
    try checkContextTaskUnlock(); //［NGKI1313］［NGKI1314］
    p_tcb = try checkAndGetTCB(tskid); //［NGKI1316］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (!isSuspended(p_tcb.tstat)) { //［NGKI1319］
            return ItronError.ObjectStateError;
        } else {
            // 強制待ちからの再開［NGKI1320］
            if (!isWaiting(p_tcb.tstat)) {
                p_tcb.tstat = TS_RUNNABLE;
                traceLog("taskStateChange", .{p_tcb});
                make_runnable(p_tcb);
                taskDispatch();
            } else {
                p_tcb.tstat &= ~@as(u8, TS_SUSPENDED);
                traceLog("taskStateChange", .{p_tcb});
            }
        }
    }
    traceLog("rsmTskLeave", .{null});
}

///
/// 自タスクの遅延［NGKI1348］
///
pub fn dly_tsk(dlytim: RELTIM) ItronError!void {
    var winfo: WINFO = undefined;
    var tmevtb: TMEVTB = undefined;

    traceLog("dlyTskEnter", .{dlytim});
    errdefer |err| traceLog("dlyTskLeave", .{err});
    try checkDispatch(); //［NGKI1349］
    try checkParameter(validRelativeTime(dlytim)); //［NGKI1351］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpuDsp();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpuDsp();

        var p_selftsk = task.p_runtsk.?;
        if (p_selftsk.flags.raster) { //［NGKI3456］
            return ItronError.TerminationRequestRaised;
        } else { //［NGKI1353］
            p_selftsk.tstat = TS_WAITING_DLY;
            make_non_runnable(p_selftsk);
            p_selftsk.p_winfo = &winfo;
            winfo.p_tmevtb = &tmevtb;
            tmevtb.callback = wait_tmout_ok;
            tmevtb.arg = @intFromPtr(task.p_runtsk);
            tmevtb_enqueue_reltim(&tmevtb, dlytim);
            traceLog("taskStateChange", .{p_selftsk});
            target_impl.mpcore_kernel_impl.core_kernel_impl.dispatch();
            if (winfo.werror) |werror| {
                return werror.*;
            }
        }
    }
    traceLog("dlyTskLeave", .{null});
}
