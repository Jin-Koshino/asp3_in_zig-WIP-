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
///  オーバランハンドラ機能
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
const cfg = kernel_impl.cfg;
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
////

///
///  オーバランハンドラ初期化ブロック
///
pub const OVRINIB = extern struct {
    ovratr: ATR, // オーバランハンドラ属性
    ovrhdr: ?OVRHDR, // オーバランハンドラの起動番地
};

///
///  オーバランハンドラ初期化ブロックの取り込み
///
pub const ExternOvrIniB = struct {
    ///
    ///  オーバランハンドラ初期化ブロックのエリア
    ///
    pub extern const _kernel_ovrinib: OVRINIB;
};

///
///  オーバランタイマの動作開始
///
pub fn overrun_start() void {
    if (comptime TOPPERS_SUPPORT_OVRHDR) {
        if (task.p_runtsk.?.flags.staovr) {
            target_timer.ovrtimer.start(task.p_runtsk.?.leftotm);
        }
    }
}

///
///  オーバランタイマの停止
///
pub fn overrun_stop() void {
    if (comptime TOPPERS_SUPPORT_OVRHDR) {
        if (task.p_runtsk != null and task.p_runtsk.?.flags.staovr) {
            task.p_runtsk.?.leftotm = target_timer.ovrtimer.stop();
        }
    }
}

///
///  オーバランハンドラの動作開始
///
pub fn sta_ovr(tskid: ID, ovrtim: PRCTIM) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("staOvrEnter", .{ tskid, ovrtim });
    errdefer |err| traceLog("staOvrLeave", .{err});
    try comptime checkNotSupported(TOPPERS_SUPPORT_OVRHDR);
    try checkContextUnlock();
    try checkObjectState(cfg._kernel_ovrinib.ovrhdr != null);
    if (tskid == TSK_SELF and !target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext()) {
        p_tcb = task.p_runtsk.?;
    } else {
        p_tcb = try checkAndGetTCB(tskid);
    }
    try checkParameter(0 < ovrtim and ovrtim <= TMAX_OVRTIM);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (!target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext() and p_tcb == task.p_runtsk) {
            if (p_tcb.flags.staovr) {
                _ = target_timer.ovrtimer.stop();
            }
            target_timer.ovrtimer.start(ovrtim);
        }
        p_tcb.flags.staovr = true;
        p_tcb.leftotm = ovrtim;
    }
    traceLog("staOvrLeave", .{null});
}

///
///  オーバランハンドラの動作停止
///
pub fn stp_ovr(tskid: ID) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("stpOvrEnter", .{tskid});
    errdefer |err| traceLog("stpOvrLeave", .{err});
    try comptime checkNotSupported(TOPPERS_SUPPORT_OVRHDR);
    try checkContextUnlock();
    try checkObjectState(cfg._kernel_ovrinib.ovrhdr != null);
    if (tskid == TSK_SELF and !target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext()) {
        p_tcb = task.p_runtsk.?;
    } else {
        p_tcb = try checkAndGetTCB(tskid);
    }
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (!target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext() and p_tcb == task.p_runtsk) {
            if (p_tcb.flags.staovr) {
                _ = target_timer.ovrtimer.stop();
            }
        }
        p_tcb.flags.staovr = false;
    }
    traceLog("stpOvrLeave", .{null});
}

///
///  オーバランハンドラの状態参照
///
pub fn ref_ovr(tskid: ID, pk_rovr: *T_ROVR) ItronError!void {
    var p_tcb: *TCB = undefined;

    traceLog("refOvrEnter", .{ tskid, pk_rovr });
    errdefer |err| traceLog("refOvrLeave", .{ err, pk_rovr });
    try comptime checkNotSupported(TOPPERS_SUPPORT_OVRHDR);
    try checkContextTaskUnlock();
    try checkObjectState(cfg._kernel_ovrinib.ovrhdr != null);
    if (tskid == TSK_SELF) {
        p_tcb = task.p_runtsk.?;
    } else {
        p_tcb = try checkAndGetTCB(tskid);
    }
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_tcb.flags.staovr) {
            pk_rovr.ovrstat = TOVR_STA;
            if (p_tcb == task.p_runtsk) {
                pk_rovr.leftotm = target_timer.ovrtimer.get_current();
            } else {
                pk_rovr.leftotm = p_tcb.leftotm;
            }
        } else {
            pk_rovr.ovrstat = TOVR_STP;
        }
    }
    traceLog("refOvrLeave", .{ null, pk_rovr });
}

///
///  オーバランハンドラ起動ルーチン
///
pub fn call_ovrhdr() void {
    if (comptime TOPPERS_SUPPORT_OVRHDR) {
        assert(target_impl.mpcore_kernel_impl.core_kernel_impl.senseContext());
        assert(!target_impl.mpcore_kernel_impl.core_kernel_impl.senseLock());
        assert(cfg._kernel_ovrinib.ovrhdr != null);

        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        if (task.p_runtsk != null and task.p_runtsk.?.flags.staovr and task.p_runtsk.?.leftotm == 0) {
            task.p_runtsk.?.flags.staovr = false;
            target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

            traceLog("overrunEnter", .{task.p_runtsk.?});
            cfg._kernel_ovrinib.ovrhdr.?(getTskIdFromTCB(task.p_runtsk.?), task.p_runtsk.?.p_tinib.exinf);
            traceLog("overrunLeave", .{task.p_runtsk.?});
        } else {
            // このルーチンが呼び出される前に，オーバランハンドラの起
            // 動がキャンセルされた場合
            target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();
        }
    }
}

///
///  オーバランハンドラの定義（静的APIの処理）
///
pub fn defineOverrun(dovr: T_DOVR) ItronError!OVRINIB {
    // ovratrが無効の場合（E_RSATR）［NGKI2612］［NGKI2602］［NGKI2603］
    //（TA_NULLでない場合）
    try checkValidAtr(dovr.ovratr, TA_NULL);

    return OVRINIB{
        .ovratr = dovr.ovratr,
        .ovrhdr = dovr.ovrhdr,
    };
}

///
///  オーバランハンドラ初期化ブロックの生成（静的APIの処理）
///
pub fn ExportOvrIniB(comptime _ovrinib: ?OVRINIB) type {
    // チェック処理用の定義の生成
    exportCheck(@sizeOf(OVRHDR), "sizeof_OVRHDR");
    exportCheck(@offsetOf(OVRINIB, "ovrhdr"), "offsetof_OVRINIB_ovrhdr");

    return struct {
        export const _kernel_ovrinib =
            if (_ovrinib) |ovrinib| ovrinib else OVRINIB{
            .ovratr = TA_NULL,
            .ovrhdr = null,
        };
    };
}
