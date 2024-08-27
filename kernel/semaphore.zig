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
///  セマフォ機能
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
const queue = kernel_impl.queue;

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
const TMIN_SEMID = kernel_impl.TMIN_SEMID;
const TS_WAITING_SEM = task.TS_WAITING_SEM;
const T_RSEM = zig.T_RSEM;
const T_CSEM = zig.T_CSEM;
const TMAX_MAXSEM = zig.TMAX_MAXSEM;
////

///
///  セマフォ初期化ブロック
///
///  この構造体は，同期・通信オブジェクトの初期化ブロックの共通部分
///  （WOBJINIB）を拡張（オブジェクト指向言語の継承に相当）したもので，
///  最初のフィールドが共通になっている．
///
pub const SEMINIB = struct {
    wobjatr: t_stddef.ATR, // セマフォ属性
    isemcnt: u32, // セマフォの資源数の初期値
    maxsem: u32, // セマフォの最大資源数
};

// セマフォ初期化ブロックのチェック
comptime {
    wait.checkWobjIniB(SEMINIB);
}

///
///  セマフォ管理ブロック
///
///  この構造体は，同期・通信オブジェクトの管理ブロックの共通部分
///  （WOBJCB）を拡張（オブジェクト指向言語の継承に相当）したもので，
///  最初の2つのフィールドが共通になっている．
///
const SEMCB = struct {
    wait_queue: queue.Queue, // セマフォ待ちキュー
    p_wobjinib: *const SEMINIB, // 初期化ブロックへのポインタ
    semcnt: u32, // セマフォ現在カウント値
};

// セマフォ管理ブロックのチェック
comptime {
    wait.checkWobjCB(SEMCB);
}

///
///  セマフォ待ち情報ブロックの定義
///
///  この構造体は，同期・通信オブジェクトの待ち情報ブロックの共通部分
///  （WINFO_WOBJ）を拡張（オブジェクト指向言語の継承に相当）したもの
///  で，すべてのフィールドが共通になっている．
///
const WINFO_SEM = struct {
    winfo: WINFO, // 標準の待ち情報ブロック
    p_wobjcb: *SEMCB, // 待っているセマフォの管理ブロック
};

// セマフォ待ち情報ブロックのチェック
comptime {
    checkWinfoWobj(WINFO_SEM);
}

///
///  セマフォに関するコンフィギュレーションデータの取り込み
///
pub const ExternSemCfg = struct {
    ///
    ///  セマフォ初期化ブロック（スライス）
    ///
    pub extern const _kernel_seminib_table: []SEMINIB;

    ///
    ///  セマフォ管理ブロックのエリア
    ///
    // Zigの制限事項の回避：十分に大きいサイズの配列とする
    pub extern var _kernel_semcb_table: [1000]SEMCB;
};

///
///  セマフォIDの最大値
///
fn maxSemId() ID {
    return @intCast(TMIN_SEMID + cfg._kernel_seminib_table.len - 1);
}

///
///  セマフォIDからセマフォ管理ブロックを取り出すための関数
///
fn indexSem(semid: ID) usize {
    return @intCast(semid - TMIN_SEMID);
}
fn checkAndGetSemCB(semid: ID) ItronError!*SEMCB {
    try checkId(TMIN_SEMID <= semid and semid <= maxSemId());
    return &cfg._kernel_semcb_table[indexSem(semid)];
}

///
///  セマフォ管理ブロックからセマフォIDを取り出すための関数
///
fn getSemIdFromSemCB(p_semcb: *SEMCB) ID {
    return @as(ID, @intCast((@intFromPtr(p_semcb) - @intFromPtr(&cfg._kernel_semcb_table)) / @sizeOf(SEMCB))) + TMIN_SEMID;
}

///
///  セマフォ待ち情報ブロックを取り出すための関数
///
pub fn getWinfoSem(p_winfo: *WINFO) *WINFO_SEM {
    return @fieldParentPtr(WINFO_SEM, "winfo", p_winfo);
}

///
///  待ち情報ブロックからセマフォIDを取り出すための関数
///
pub fn getSemIdFromWinfo(p_winfo: *WINFO) ID {
    return getSemIdFromSemCB(getWinfoSem(p_winfo).p_wobjcb);
}

///
///  セマフォ機能の初期化
///
pub fn initialize_semaphore() void {
    for (cfg._kernel_semcb_table[0..cfg._kernel_seminib_table.len]) |*p_semcb, i| {
        p_semcb.wait_queue.initialize();
        p_semcb.p_wobjinib = &cfg._kernel_seminib_table[i];
        p_semcb.semcnt = p_semcb.p_wobjinib.isemcnt;
    }
}

///
///  セマフォ資源の返却
///
pub fn sig_sem(semid: ID) ItronError!void {
    traceLog("sigSemEnter", .{semid});
    errdefer |err| traceLog("sigSemLeave", .{err});
    try checkContextUnlock();
    const p_semcb = try checkAndGetSemCB(semid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (!p_semcb.wait_queue.isEmpty()) {
            const p_tcb = getTCBFromQueue(p_semcb.wait_queue.deleteNext());
            wait_complete(p_tcb);
            requestTaskDispatch();
        } else if (p_semcb.semcnt < p_semcb.p_wobjinib.maxsem) {
            p_semcb.semcnt += 1;
        } else {
            return ItronError.QueueingOverflow;
        }
    }
    traceLog("sigSemLeave", .{null});
}

///
///  セマフォ資源の獲得
///
pub fn wai_sem(semid: ID) ItronError!void {
    traceLog("waiSemEnter", .{semid});
    errdefer |err| traceLog("waiSemLeave", .{err});
    try checkDispatch();
    const p_semcb = try checkAndGetSemCB(semid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpuDsp();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpuDsp();

        if (task.p_runtsk.?.flags.raster) {
            return ItronError.TerminationRequestRaised;
        } else if (p_semcb.semcnt >= 1) {
            p_semcb.semcnt -= 1;
        } else {
            var winfo_sem: WINFO_SEM = undefined;
            wobj_make_wait(p_semcb, TS_WAITING_SEM, &winfo_sem);
            target_impl.mpcore_kernel_impl.core_kernel_impl.dispatch();
            if (winfo_sem.winfo.werror) |werror| {
                return werror;
            }
        }
    }
    traceLog("waiSemLeave", .{null});
}

///
///  セマフォ資源の獲得（ポーリング）
///
pub fn pol_sem(semid: ID) ItronError!void {
    traceLog("polSemEnter", .{semid});
    errdefer |err| traceLog("polSemLeave", .{err});
    try checkContextTaskUnlock();
    const p_semcb = try checkAndGetSemCB(semid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_semcb.semcnt >= 1) {
            p_semcb.semcnt -= 1;
        } else {
            return ItronError.TimeoutError;
        }
    }
    traceLog("polSemLeave", .{null});
}

///
///  セマフォ資源の獲得（タイムアウトあり）
///
pub fn twai_sem(semid: ID, tmout: TMO) ItronError!void {
    traceLog("tWaiSemEnter", .{ semid, tmout });
    errdefer |err| traceLog("tWaiSemLeave", .{err});
    try checkDispatch();
    const p_semcb = try checkAndGetSemCB(semid);
    try checkParameter(validTimeout(tmout));
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpuDsp();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpuDsp();

        if (task.p_runtsk.?.flags.raster) {
            return ItronError.TerminationRequestRaised;
        } else if (p_semcb.semcnt >= 1) {
            p_semcb.semcnt -= 1;
        } else if (tmout == TMO_POL) {
            return ItronError.TimeoutError;
        } else {
            var winfo_sem: WINFO_SEM = undefined;
            var tmevtb: TMEVTB = undefined;
            wobj_make_wait_tmout(p_semcb, TS_WAITING_SEM, &winfo_sem, &tmevtb, tmout);
            target_impl.mpcore_kernel_impl.core_kernel_impl.dispatch();
            if (winfo_sem.winfo.werror) |werror| {
                return werror;
            }
        }
    }
    traceLog("tWaiSemLeave", .{null});
}

///
///  セマフォの再初期化
///
pub fn ini_sem(semid: ID) ItronError!void {
    traceLog("iniSemEnter", .{semid});
    errdefer |err| traceLog("iniSemLeave", .{err});
    try checkContextTaskUnlock();
    const p_semcb = try checkAndGetSemCB(semid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        init_wait_queue(&p_semcb.wait_queue);
        p_semcb.semcnt = p_semcb.p_wobjinib.isemcnt;
        taskDispatch();
    }
    traceLog("iniSemLeave", .{null});
}

///
///  セマフォの状態参照
///
pub fn ref_sem(semid: ID, pk_rsem: *T_RSEM) ItronError!void {
    traceLog("refSemEnter", .{ semid, pk_rsem });
    errdefer |err| traceLog("refSemLeave", .{ err, pk_rsem });
    try checkContextTaskUnlock();
    const p_semcb = try checkAndGetSemCB(semid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        pk_rsem.wtskid = wait_tskid(&p_semcb.wait_queue);
        pk_rsem.semcnt = p_semcb.semcnt;
    }
    traceLog("refSemLeave", .{ null, pk_rsem });
}

///
///  セマフォの生成（静的APIの処理）
///
pub fn cre_sem(csem: T_CSEM) ItronError!SEMINIB {
    // sematrが無効の場合（E_RSATR）［NGKI1456］［NGKI1448］
    //（TA_TPRI以外のビットがセットされている場合）
    try checkValidAtr(csem.sematr, TA_TPRI);

    // maxsemが有効範囲外の場合（E_PAR）［NGKI1468］
    //（1 <= maxsem && maxsem <= TMAX_MAXSEMでない場合）
    try checkParameter(1 <= csem.maxsem and csem.maxsem <= TMAX_MAXSEM);

    // isemcntが有効範囲外の場合（E_PAR）［NGKI1466］
    //（0 <= isemcnt && isemcnt <= maxsemでない場合）
    try checkParameter(0 <= csem.isemcnt and csem.isemcnt <= csem.maxsem);

    // セマフォ初期化ブロックを返す
    return SEMINIB{
        .wobjatr = csem.sematr,
        .isemcnt = csem.isemcnt,
        .maxsem = csem.maxsem,
    };
}

///
///  セマフォに関するコンフィギュレーションデータの生成（静的APIの処理）
///
pub fn ExportSemCfg(seminib_table: []SEMINIB) type {
    const tnum_sem = seminib_table.len;
    return struct {
        pub export const _kernel_seminib_table = seminib_table;

        // Zigの制限の回避：BIND_CFG != nullの場合に，サイズ0の配列が
        // 出ないようにする
        pub export var _kernel_semcb_table: [
            if (option.BIND_CFG == null or tnum_sem > 0) tnum_sem else 1
        ]SEMCB = undefined;
    };
}
