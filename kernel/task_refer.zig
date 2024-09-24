///
///  TOPPERS/ASP Kernel
///      Toyohashi Open Platform for Embedded Real-Time Systems/
///      Advanced Standard Profile Kernel
///
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
///  タスクの状態参照機能
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
////

///
///  待ち要因と待ち対象のオブジェクトのIDの取出し［NGKI1229］［NGKI1231］
///
fn referWaitingState(p_tcb: *TCB, pk_rtsk: *T_RTSK) void {
    switch (p_tcb.tstat & TS_WAITING_MASK) {
        TS_WAITING_SLP => {
            pk_rtsk.tskwait = TTW_SLP;
        },
        TS_WAITING_DLY => {
            pk_rtsk.tskwait = TTW_DLY;
        },
        TS_WAITING_SEM => {
            pk_rtsk.tskwait = TTW_SEM;
            pk_rtsk.wobjid = semaphore.getSemIdFromWinfo(p_tcb.p_winfo);
        },
        TS_WAITING_FLG => {
            pk_rtsk.tskwait = TTW_FLG;
            pk_rtsk.wobjid = eventflag.getFlgIdFromWinfo(p_tcb.p_winfo);
        },
        TS_WAITING_SDTQ => {
            pk_rtsk.tskwait = TTW_SDTQ;
            pk_rtsk.wobjid = dataqueue.getDtqIdFromWinfoSDtq(p_tcb.p_winfo);
        },
        TS_WAITING_RDTQ => {
            pk_rtsk.tskwait = TTW_RDTQ;
            pk_rtsk.wobjid = dataqueue.getDtqIdFromWinfoRDtq(p_tcb.p_winfo);
        },
        TS_WAITING_SPDQ => {
            pk_rtsk.tskwait = TTW_SPDQ;
            pk_rtsk.wobjid = pridataq.getPdqIdFromWinfoSPdq(p_tcb.p_winfo);
        },
        TS_WAITING_RPDQ => {
            pk_rtsk.tskwait = TTW_RPDQ;
            pk_rtsk.wobjid = pridataq.getPdqIdFromWinfoRPdq(p_tcb.p_winfo);
        },
        TS_WAITING_MTX => {
            pk_rtsk.wobjid = mutex.getMtxIdFromWinfo(p_tcb.p_winfo);
        },
        TS_WAITING_MPF => {
            pk_rtsk.tskwait = TTW_MPF;
            pk_rtsk.wobjid = mempfix.getMpfIdFromWinfo(p_tcb.p_winfo);
        },
        else => unreachable,
    }
}

///
///  タスクの状態参照［NGKI1217］
///
pub fn ref_tsk(tskid: ID, pk_rtsk: *T_RTSK) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("refTskEnter", .{ tskid, pk_rtsk });
    errdefer |err| traceLog("refTskLeave", .{ err, pk_rtsk });
    try checkContextTaskUnlock(); //［NGKI1218］［NGKI1219］
    if (tskid == TSK_SELF) {
        p_tcb = task.p_runtsk.?; //［NGKI1248］
    } else {
        p_tcb = try checkAndGetTCB(tskid); //［NGKI1220］
    }
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        var tstat = p_tcb.tstat;
        if (isDormant(tstat)) {
            // 対象タスクが休止状態の場合［NGKI1225］
            pk_rtsk.tskstat = TTS_DMT;
        } else {
            // タスク状態の取出し［NGKI1225］
            if (isWaiting(tstat)) {
                if (isSuspended(tstat)) {
                    pk_rtsk.tskstat = TTS_WAS;
                } else {
                    pk_rtsk.tskstat = TTS_WAI;
                }

                // 待ち要因と待ち対象のオブジェクトのIDの取出し
                referWaitingState(p_tcb, pk_rtsk);

                // タイムアウトするまでの時間の取出し
                if (p_tcb.p_winfo.p_tmevtb) |p_tmevtb| {
                    pk_rtsk.lefttmo = @as(TMO, @intCast(tmevt_lefttim(p_tmevtb)));
                } //［NGKI1233］［NGKI1235］
                else {
                    pk_rtsk.lefttmo = TMO_FEVR; //［NGKI1234］
                }
            } else if (isSuspended(tstat)) {
                pk_rtsk.tskstat = TTS_SUS;
            } else if (p_tcb == task.p_runtsk) {
                pk_rtsk.tskstat = TTS_RUN;
            } else {
                pk_rtsk.tskstat = TTS_RDY;
            }

            // 現在優先度とベース優先度の取出し［NGKI1227］
            pk_rtsk.tskpri = externalTaskPrio(p_tcb.prios.prio);
            pk_rtsk.tskbpri = externalTaskPrio(p_tcb.prios.bprio);

            // 起床要求キューイング数の取出し［NGKI1239］
            pk_rtsk.wupcnt = p_tcb.flags.wupque;

            // タスク終了要求状態の取出し［NGKI3467］
            pk_rtsk.raster = @intFromBool(p_tcb.flags.raster);

            // タスク終了禁止状態の取出し［NGKI3468］
            pk_rtsk.dister = @intFromBool(!p_tcb.flags.enater);
        }

        // 起動要求キューイング数の取出し［NGKI1238］
        pk_rtsk.actcnt = p_tcb.flags.actque;
    }
    traceLog("refTskLeave", .{ null, pk_rtsk });
}
