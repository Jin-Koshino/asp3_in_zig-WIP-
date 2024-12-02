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
///  ミューテックス機能
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
const TMIN_MPFID = kernel_impl.TMIN_MPFID;
const TS_WAITING_MPF = task.TS_WAITING_MPF;
const ptrAlignCast = kernel_impl.ptrAlignCast;
const T_RMPF = zig.T_RMPF;
const T_CMPF = zig.T_CMPF;
const TOPPERS_ROUND_SZ = zig.TOPPERS_ROUND_SZ;
const exportCheck = kernel_impl.exportCheck;
const TCB = task.TCB;
const TMIN_MTXID = kernel_impl.TMIN_MTXID;
const TA_CEILING = zig.TA_CEILING;
const TaskPrio = task.TaskPrio;
const isWaitingMtx = task.isWaitingMtx;
const change_priority = task.change_priority;
const wait_dequeue_tmevtb = wait.wait_dequeue_tmevtb;
const make_non_wait = wait.make_non_wait;
const assert = t_stddef.assert;
const TS_WAITING_MTX = task.TS_WAITING_MTX;
const T_RMTX = zig.T_RMTX;
const getTskIdFromTCB = task.getTskIdFromTCB;
const TSK_NONE = zig.TSK_NONE;
const T_CMTX = zig.T_CMTX;
const checkAttribute = check.checkAttribute;
const TA_NULL = t_stddef.TA_NULL;
const validTaskPri = task.validTaskPri;
const internalTaskPrio = task.internalTaskPrio;
const checkBit = check.checkBit;
const TMIN_TPRI = zig.TMIN_TPRI;
const validTCB = task.validTCB;
////

///
///  ミューテックス初期化ブロック
///
///  この構造体は，同期・通信オブジェクトの初期化ブロックの共通部分
///  （WOBJINIB）を拡張（オブジェクト指向言語の継承に相当）したもので，
///  最初のフィールドが共通になっている．
///
pub const MTXINIB = extern struct {
    wobjatr: ATR, // ミューテックス属性
    ceilpri: c_uint, // ミューテックスの上限優先度（内部表現）
};

// ミューテックス初期化ブロックのチェック
comptime {
    wait.checkWobjIniB(MTXINIB);
}

///
///  ミューテックス管理ブロック
///
///  この構造体は，同期・通信オブジェクトの管理ブロックの共通部分
///  （WOBJCB）を拡張（オブジェクト指向言語の継承に相当）したもので，
///  最初の2つのフィールドが共通になっている．
///
pub const MTXCB = extern struct {
    wait_queue: queue.Queue, // ミューテックス待ちキュー
    p_wobjinib: *const MTXINIB, // 初期化ブロックへのポインタ
    p_loctsk: ?*TCB, // ミューテックスをロックしているタスク
    p_prevmtx: ?*MTXCB, // この前にロックしたミューテックス
};

// ミューテックス管理ブロックのチェック
comptime {
    checkWobjCB(MTXCB);
}

///
///  ミューテックス待ち情報ブロックの定義
///
///  この構造体は，同期・通信オブジェクトの待ち情報ブロックの共通部分
///  （WINFO_WOBJ）を拡張（オブジェクト指向言語の継承に相当）したもの
///  で，すべてのフィールドが共通になっている．
///
pub const WINFO_MTX = struct {
    winfo: WINFO, // 標準の待ち情報ブロック
    p_wobjcb: *MTXCB, // 待っているミューテックスの管理ブロック
};

// ミューテックス待ち情報ブロックのチェック
comptime {
    checkWinfoWobj(WINFO_MTX);
}

///
///  ミューテックスに関するコンフィギュレーションデータの取り込み
///
pub const ExternMtxCfg = struct {
    ///
    ///  ミューテックスIDの最大値
    ///
    pub extern const _kernel_tmax_mtxid: ID;

    ///
    ///  ミューテックス初期化ブロック（スライス）
    ///
    pub extern const _kernel_mtxinib_table: [100]MTXINIB;

    ///
    ///  ミューテックス管理ブロックのエリア
    ///
    // Zigの制限事項の回避：十分に大きいサイズの配列とする
    pub extern var _kernel_mtxcb_table: [100]MTXCB;
};

///
///  ミューテックスIDの最大値
///
fn maxMtxId() ID {
    return @intCast(TMIN_MTXID + cfg._kernel_mtxinib_table.len - 1);
}

///
///  ミューテックスの数
///
fn numOfMtx() usize {
    return @intCast(cfg._kernel_tmax_mtxid - TMIN_MTXID + 1);
}

///
///  ミューテックスのプロトコルを判断する関数
///
const MTXPROTO_MASK = 0x03;
fn isCeilingMtx(p_mtxcb: *MTXCB) bool {
    return (p_mtxcb.p_wobjinib.wobjatr & MTXPROTO_MASK) == TA_CEILING;
}

///
///  ミューテックスIDからミューテックス管理ブロックを取り出すための関数
///
fn indexMtx(mtxid: ID) usize {
    return @intCast(mtxid - TMIN_MTXID);
}
fn checkAndGetMtxCB(mtxid: ID) ItronError!*MTXCB {
    try checkId(TMIN_MTXID <= mtxid and mtxid <= cfg._kernel_tmax_mtxid);
    return &cfg._kernel_mtxcb_table[indexMtx(mtxid)];
}

///
///  ミューテックス管理ブロックからミューテックスIDを取り出すための関数
///
pub fn getMtxIdFromMtxCB(p_mtxcb: *MTXCB) ID {
    return @as(ID, @intCast((@intFromPtr(p_mtxcb) - @intFromPtr(&cfg._kernel_mtxcb_table)) / @sizeOf(MTXCB))) + TMIN_MTXID;
}

///
///  ミューテックス待ち情報ブロックを取り出すための関数
///
pub fn getWinfoMtx(p_winfo: *WINFO) *WINFO_MTX {
    return @fieldParentPtr(WINFO_MTX, "winfo", p_winfo);
}

///
///  待ち情報ブロックからミューテックスIDを取り出すための関数
///
pub fn getMtxIdFromWinfo(p_winfo: *WINFO) ID {
    return getMtxIdFromMtxCB(getWinfoMtx(p_winfo).p_wobjcb);
}

///
///  ミューテックス機能の初期化
///
pub fn initialize_mutex() void {
    task.mtxhook_check_ceilpri = @constCast(&mutexCheckCeilpri);
    task.mtxhook_scan_ceilmtx = @constCast(&mutexScanCeilMtx);
    task.mtxhook_release_all = @constCast(&mutexReleaseAll);

    for (cfg._kernel_mtxcb_table[0..numOfMtx()], 0..) |*p_mtxcb, i| {
        p_mtxcb.wait_queue.initialize();
        p_mtxcb.p_wobjinib = &cfg._kernel_mtxinib_table[i];
        p_mtxcb.p_loctsk = null;
    }
}

///
///  上限優先度違反のチェック
///
///  chg_priの中で上限優先度違反のチェックを行うために用いる関数であり，
///  p_tcbで指定されるタスクがロックしている優先度上限ミューテックスと，
///  ロックを待っている優先度上限ミューテックスの中で，上限優先度が
///  bpriorityよりも低いものがあればfalseを，そうでなければtrueを返す．
///
fn mutexCheckCeilpri(p_tcb: *TCB, bprio: TaskPrio) bool {
    var op_mtxcb = p_tcb.p_lastmtx;

    // タスクがロックしている優先度上限ミューテックスの中で，上限優先
    // 度がbprioよりも低いものがあれば，falseを返す．
    while (op_mtxcb) |p_mtxcb| : (op_mtxcb = p_mtxcb.p_prevmtx) {
        if (isCeilingMtx(p_mtxcb) and bprio < p_mtxcb.p_wobjinib.ceilpri) {
            return false;
        }
    }

    // タスクが優先度上限ミューテックスのロックを待っている場合に，そ
    // の上限優先度がbprioよりも低くければ，falseを返す．
    if (isWaitingMtx(p_tcb.tstat)) {
        const p_mtxcb = getWinfoMtx(p_tcb.p_winfo).p_wobjcb;
        if (isCeilingMtx(p_mtxcb) and bprio < p_mtxcb.p_wobjinib.ceilpri) {
            return false;
        }
    }

    // いずれの条件にも当てはまらなければtrueを返す．
    return true;
}

///
///  優先度上限ミューテックスをロックしているかのチェック
///
///  p_tcbで指定されるタスクが優先度上限ミューテックスをロックしていれ
///  ばtrue，そうでなければfalseを返す．
///
fn mutexScanCeilMtx(p_tcb: *TCB) bool {
    var op_mtxcb = p_tcb.p_lastmtx;

    while (op_mtxcb) |p_mtxcb| : (op_mtxcb = p_mtxcb.p_prevmtx) {
        if (isCeilingMtx(p_mtxcb)) {
            return true;
        }
    }
    return false;
}

///
///  タスクの現在優先度の計算
///
///  p_tcbで指定されるタスクの現在優先度（に設定すべき値）を計算する．
///
fn mutexCalcPriority(p_tcb: *TCB) TaskPrio {
    var prio = p_tcb.prios.bprio;
    var op_mtxcb = p_tcb.p_lastmtx;

    while (op_mtxcb) |p_mtxcb| : (op_mtxcb = p_mtxcb.p_prevmtx) {
        if (isCeilingMtx(p_mtxcb) and p_mtxcb.p_wobjinib.ceilpri < prio) {
            prio = @as(TaskPrio, @intCast(p_mtxcb.p_wobjinib.ceilpri));
        }
    }
    return prio;
}

///
///  ミューテックスを解放した場合の現在優先度変更処理
///
///  p_tcbで指定されるタスクが，p_mtxcbで指定されるミューテックスをロッ
///  ク解除した際の現在優先度変更処理を行う．
///
fn mutexDropPriority(p_tcb: *TCB, p_mtxcb: *MTXCB) void {
    if (isCeilingMtx(p_mtxcb) and p_mtxcb.p_wobjinib.ceilpri == p_tcb.prios.prio) {
        const newprio = mutexCalcPriority(p_tcb);
        if (newprio != p_tcb.prios.prio) {
            change_priority(p_tcb, newprio, true);
        }
    }
}

///
///  ミューテックスのロック
///
///  p_tcbで指定されるタスクに，p_mtxcbで指定されるミューテックスをロッ
///  クさせる．
///
fn mutexAcquire(p_tcb: *TCB, p_mtxcb: *MTXCB) void {
    p_mtxcb.p_loctsk = p_tcb;
    p_mtxcb.p_prevmtx = p_tcb.p_lastmtx;
    p_tcb.p_lastmtx = p_mtxcb;
    if (isCeilingMtx(p_mtxcb) and p_mtxcb.p_wobjinib.ceilpri < p_tcb.prios.prio) {
        change_priority(p_tcb, @as(TaskPrio, @intCast(p_mtxcb.p_wobjinib.ceilpri)), true);
    }
}

///
///  ミューテックスのロック解除
///
///  p_mtxcbで指定されるミューテックスをロック解除する．ロック解除した
///  ミューテックスに，ロック待ち状態のタスクがある場合には，そのタス
///  クにミューテックスをロックさせる．
///
fn mutexRelease(p_mtxcb: *MTXCB) void {
    if (p_mtxcb.wait_queue.isEmpty()) {
        p_mtxcb.p_loctsk = null;
    } else {
        // ミューテックス待ちキューの先頭タスク（p_tcb）に，ミューテッ
        // クスをロックさせる．
        const p_tcb = getTCBFromQueue(p_mtxcb.wait_queue.deleteNext());
        wait_dequeue_tmevtb(p_tcb);
        p_tcb.p_winfo.* = WINFO{ .werror = null };

        p_mtxcb.p_loctsk = p_tcb;
        p_mtxcb.p_prevmtx = p_tcb.p_lastmtx;
        p_tcb.p_lastmtx = p_mtxcb;
        if (isCeilingMtx(p_mtxcb) and p_mtxcb.p_wobjinib.ceilpri < p_tcb.prios.prio) {
            p_tcb.prios.prio = @as(TaskPrio, @intCast(p_mtxcb.p_wobjinib.ceilpri));
        }
        make_non_wait(p_tcb);
    }
}

///
///  タスクがロックしているすべてのミューテックスのロック解除
///
///  p_tcbで指定されるタスクに，それがロックしているすべてのミューテッ
///  クスをロック解除させる．ロック解除したミューテックスに，ロック待
///  ち状態のタスクがある場合には，そのタスクにミューテックスをロック
///  させる．
///
///  この関数は，タスクの終了時に使われるものであるため，p_tcbで指定さ
///  れるタスクの優先度を変更する処理は行わない．ただし，この関数の中
///  で他のタスクの優先度が変化し，実行すべきタスクが変わることがある．
///  そのため，この関数から戻った後に，ディスパッチが必要か判別して，
///  必要な場合にはディスパッチを行わなければならない．
///
fn mutexReleaseAll(p_tcb: *TCB) void {
    while (p_tcb.p_lastmtx) |p_mtxcb| {
        p_tcb.p_lastmtx = p_mtxcb.p_prevmtx;
        mutexRelease(p_mtxcb);
    }
}

///
///  ミューテックスのロック
///
pub fn loc_mtx(mtxid: ID) ItronError!void {
    traceLog("locMtxEnter", .{mtxid});
    errdefer |err| traceLog("locMtxLeave", .{err});
    try checkDispatch();
    const p_mtxcb = try checkAndGetMtxCB(mtxid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpuDsp();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpuDsp();

        if (task.p_runtsk.?.flags.raster) {
            return ItronError.TerminationRequestRaised;
        } else if (isCeilingMtx(p_mtxcb) and task.p_runtsk.?.prios.bprio < p_mtxcb.p_wobjinib.ceilpri) {
            return ItronError.IllegalUse;
        } else if (p_mtxcb.p_loctsk == null) {
            mutexAcquire(task.p_runtsk.?, p_mtxcb);
            // 優先度上限ミューテックスをロックした場合，p_runtskの優
            // 先度が上がる可能性があるが，ディスパッチが必要になるこ
            // とはない．
            assert(task.p_runtsk == task.p_schedtsk, null);
        } else if (p_mtxcb.p_loctsk == task.p_runtsk) {
            return ItronError.ObjectStateError;
        } else {
            var winfo_mtx: WINFO_MTX = undefined;
            wobj_make_wait(p_mtxcb, TS_WAITING_MTX, &winfo_mtx);
            target_impl.mpcore_kernel_impl.core_kernel_impl.dispatch();
            if (winfo_mtx.winfo.werror) |werror| {
                return werror.*;
            }
        }
    }
    traceLog("locMtxLeave", .{null});
}

///
///  ミューテックスのロック（ポーリング）
///
pub fn ploc_mtx(mtxid: ID) ItronError!void {
    traceLog("pLocMtxEnter", .{mtxid});
    errdefer |err| traceLog("pLocMtxLeave", .{err});
    try checkContextTaskUnlock();
    const p_mtxcb = try checkAndGetMtxCB(mtxid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (isCeilingMtx(p_mtxcb) and task.p_runtsk.?.prios.bprio < p_mtxcb.p_wobjinib.ceilpri) {
            return ItronError.IllegalUse;
        } else if (p_mtxcb.p_loctsk == null) {
            mutexAcquire(task.p_runtsk.?, p_mtxcb);
            // 優先度上限ミューテックスをロックした場合，p_runtskの優先度
            // が上がる可能性があるが，ディスパッチが必要になることはない．
            assert(task.p_runtsk == task.p_schedtsk, null);
        } else if (p_mtxcb.p_loctsk == task.p_runtsk) {
            return ItronError.ObjectStateError;
        } else {
            return ItronError.TimeoutError;
        }
    }
    traceLog("pLocMtxLeave", .{null});
}

///
///  ミューテックスのロック（タイムアウトあり）
///
pub fn tloc_mtx(mtxid: ID, tmout: TMO) ItronError!void {
    traceLog("tLocMtxEnter", .{ mtxid, tmout });
    errdefer |err| traceLog("tLocMtxLeave", .{err});
    try checkDispatch();
    const p_mtxcb = try checkAndGetMtxCB(mtxid);
    try checkParameter(validTimeout(tmout));
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (task.p_runtsk.?.flags.raster) {
            return ItronError.TerminationRequestRaised;
        } else if (isCeilingMtx(p_mtxcb) and task.p_runtsk.?.prios.bprio < p_mtxcb.p_wobjinib.ceilpri) {
            return ItronError.IllegalUse;
        } else if (p_mtxcb.p_loctsk == null) {
            mutexAcquire(task.p_runtsk.?, p_mtxcb);
            // 優先度上限ミューテックスをロックした場合，p_runtskの優
            // 先度が上がる可能性があるが，ディスパッチが必要になるこ
            // とはない．
            assert(task.p_runtsk == task.p_schedtsk, null);
        } else if (p_mtxcb.p_loctsk == task.p_runtsk) {
            return ItronError.ObjectStateError;
        } else if (tmout == TMO_POL) {
            return ItronError.TimeoutError;
        } else {
            var winfo_mtx: WINFO_MTX = undefined;
            var tmevtb: TMEVTB = undefined;
            wobj_make_wait_tmout(p_mtxcb, TS_WAITING_MTX, &winfo_mtx, &tmevtb, tmout);
            target_impl.mpcore_kernel_impl.core_kernel_impl.dispatch();
            if (winfo_mtx.winfo.werror) |werror| {
                return werror.*;
            }
        }
    }
    traceLog("tLocMtxLeave", .{null});
}

///
///  ミューテックスのロック解除
///
pub fn unl_mtx(mtxid: ID) ItronError!void {
    traceLog("unlMtxEnter", .{mtxid});
    errdefer |err| traceLog("unlMtxLeave", .{err});
    try checkContextTaskUnlock();
    const p_mtxcb = try checkAndGetMtxCB(mtxid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_mtxcb != task.p_runtsk.?.p_lastmtx) {
            return ItronError.ObjectStateError;
        } else {
            task.p_runtsk.?.p_lastmtx = p_mtxcb.p_prevmtx;
            mutexDropPriority(task.p_runtsk.?, p_mtxcb);
            mutexRelease(p_mtxcb);
            taskDispatch();
        }
    }
    traceLog("unlMtxLeave", .{null});
}

///
///  ミューテックスの再初期化
///
pub fn ini_mtx(mtxid: ID) ItronError!void {
    traceLog("iniMtxEnter", .{mtxid});
    errdefer |err| traceLog("iniMtxLeave", .{err});
    try checkContextTaskUnlock();
    const p_mtxcb = try checkAndGetMtxCB(mtxid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        init_wait_queue(&p_mtxcb.wait_queue);
        if (p_mtxcb.p_loctsk) |p_loctsk| {
            p_mtxcb.p_loctsk = null;
            var pp_prevmtx = @as(*?*MTXCB, @ptrCast(&p_loctsk.p_lastmtx));
            while (pp_prevmtx.*) |p_prevmtx| : (pp_prevmtx = &p_prevmtx.p_prevmtx) {
                if (p_prevmtx == p_mtxcb) {
                    pp_prevmtx.* = p_mtxcb.p_prevmtx;
                    break;
                }
            }
            mutexDropPriority(p_loctsk, p_mtxcb);
        }
        taskDispatch();
    }
    traceLog("iniMtxLeave", .{null});
}

///
///  ミューテックスの状態参照
///
pub fn ref_mtx(mtxid: ID, pk_rmtx: *T_RMTX) ItronError!void {
    traceLog("refMtxEnter", .{ mtxid, pk_rmtx });
    errdefer |err| traceLog("refMtxLeave", .{ err, pk_rmtx });
    try checkContextTaskUnlock();
    const p_mtxcb = try checkAndGetMtxCB(mtxid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_mtxcb.p_loctsk) |p_loctsk| {
            pk_rmtx.htskid = getTskIdFromTCB(p_loctsk);
        } else {
            pk_rmtx.htskid = TSK_NONE;
        }
        pk_rmtx.wtskid = wait_tskid(&p_mtxcb.wait_queue);
    }
    traceLog("refMtxLeave", .{ null, pk_rmtx });
}

///
///  ミューテックスの生成（静的APIの処理）
///
pub fn cre_mtx(cmtx: T_CMTX) ItronError!MTXINIB {
    // mtxatrが無効の場合（E_RSATR）［NGKI2025］［NGKI2010］
    //（TA_NULL，TA_TPRI，TA_CEILINGのいずれでもない場合）
    try checkAttribute(cmtx.mtxatr == TA_NULL or cmtx.mtxatr == TA_TPRI or cmtx.mtxatr == TA_CEILING);

    // ceilpriが有効範囲外の場合（E_PAR）［NGKI2037］
    //（TMIN_TPRI <= ceilpri && ceilpri <= TMAX_TPRIでない場合）
    if (cmtx.mtxatr == TA_CEILING) {
        try checkParameter(validTaskPri(cmtx.ceilpri));
    }

    // ミューテックス初期化ブロックを返す
    return MTXINIB{
        .wobjatr = cmtx.mtxatr,
        .ceilpri = if (cmtx.mtxatr == TA_CEILING)
            internalTaskPrio(cmtx.ceilpri)
        else
            0,
    };
}

///
///  ミューテックスに関するコンフィギュレーションデータの取り込み（静
///  的APIの処理）
///
pub fn ExportMtxCfg(comptime mtxinib_table: []MTXINIB) type {
    const tnum_mtx = mtxinib_table.len;
    return struct {
        pub export const _kernel_tmax_mtxid: ID = tnum_mtx;

        // Zigの制限の回避：BIND_CFG != nullの場合に，サイズ0の配列が
        // 出ないようにする
        pub export const _kernel_mtxinib_table =
            if (option.BIND_CFG == null or tnum_mtx > 0)
                mtxinib_table[0 .. tnum_mtx].*
            else [1]MTXINIB{ .{ .wobjatr = 0, .ceilpri = 0, }};

        pub export var _kernel_mtxcb_table: [
            if (option.BIND_CFG == null or tnum_mtx > 0) tnum_mtx else 1
        ]MTXCB = undefined;
    };
}

///
///  カーネルの整合性検査のための関数
///
///
///  ミューテックス管理ブロックのポインタのチェック
///
pub fn validMTXCB(p_mtxcb: *MTXCB) bool {
    if ((@intFromPtr(p_mtxcb) - @intFromPtr(&cfg._kernel_mtxcb_table)) % @sizeOf(MTXCB) != 0) {
        return false;
    }
    const mtxid = getMtxIdFromMtxCB(p_mtxcb);
    return (TMIN_MTXID <= mtxid and mtxid <= cfg._kernel_tmax_mtxid);
}

///
///  ミューテックス毎の整合性検査
///
fn bitMTXCB(p_mtxcb: *MTXCB) ItronError!void {
    const p_mtxinib = p_mtxcb.p_wobjinib;

    // ミューテックス初期化ブロックへのポインタの整合性検査
    try checkBit(p_mtxinib ==
        &cfg._kernel_mtxinib_table[indexMtx(getMtxIdFromMtxCB(p_mtxcb))]);

    // ミューテックス待ちキューの検査
    var p_entry = p_mtxcb.wait_queue.p_next;
    try checkBit(p_entry.p_prev == &p_mtxcb.wait_queue);

    var prio: TaskPrio = TMIN_TPRI;
    while (p_entry != &p_mtxcb.wait_queue) {
        const p_tcb = getTCBFromQueue(p_entry);
        try checkBit(validTCB(p_tcb));

        // キューがタスク優先度順になっているかの検査
        if ((p_mtxinib.wobjatr & MTXPROTO_MASK) != TA_NULL) {
            try checkBit(p_tcb.prios.prio >= prio);
        }
        prio = p_tcb.prios.prio;

        // タスク状態の検査
        //
        // ミューテックス待ち状態のタスクの検査は，タスク毎の検査で行っ
        // ているため，ここでは行わない．
        //
        try checkBit(isWaitingMtx(p_tcb.tstat));

        // 優先度上限の検査
        if (isCeilingMtx(p_mtxcb)) {
            try checkBit(p_tcb.prios.bprio >= p_mtxinib.ceilpri);
        }

        // キューの次の要素に進む
        const p_next = p_entry.p_next;
        try checkBit(p_entry.p_next.p_prev == p_entry);
        p_entry = p_next;
    }

    // ミューテックスをロックしているタスクの検査
    // ★未完成

    //    return ItronError.SystemError;
}

///
///  ミューテックスに関する整合性検査
///
pub fn bitMutex() ItronError!void {
    // ミューテックス毎の整合性検査
    for (cfg._kernel_mtxcb_table[0..numOfMtx()]) |*p_mtxcb| {
        try bitMTXCB(p_mtxcb);
    }
}
