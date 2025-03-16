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
///  アラーム通知機能
///
const kernel_impl = @import("kernel_impl.zig");
///usingnamespace kernel_impl.time_event;
const time_event = kernel_impl.time_event;
///usingnamespace kernel_impl.check;
const check = kernel_impl.check;

////
const zig = kernel_impl.zig;
const t_stddef = zig.t_stddef;

const ATR = t_stddef.ATR;
const EXINF = t_stddef.EXINF;
const NFYHDR = kernel_impl.NFYHDR;
const TMEVTB = time_event.TMEVTB;
const ID = t_stddef.ID;
const TMIN_ALMID = kernel_impl.TMIN_ALMID;
const cfg = kernel_impl.cfg;
const ItronError = t_stddef.ItronError;
const checkId = check.checkId;
const RELTIM = t_stddef.RELTIM;
const traceLog = kernel_impl.traceLog;
const checkContextUnlock = check.checkContextUnlock;
const checkParameter = check.checkParameter;
const validRelativeTime = check.validRelativeTime;
const target_impl = kernel_impl.target_impl;
const tmevtb_dequeue = time_event.tmevtb_dequeue;
const tmevtb_enqueue_reltim = time_event.tmevtb_enqueue_reltim;
const T_RALM = zig.T_RALM;
const checkContextTaskUnlock = check.checkContextTaskUnlock;
const TALM_STA = zig.TALM_STA;
const tmevt_lefttim = time_event.tmevt_lefttim;
const TALM_STP = zig.TALM_STP;
const T_CALM = zig.T_CALM;
const checkValidAtr = check.checkValidAtr;
const TA_NULL = t_stddef.TA_NULL;
const notify = kernel_impl.notify;
const exportCheck = kernel_impl.exportCheck;
const option = kernel_impl.option;
////

///
///  アラーム通知初期化ブロック
///
pub const ALMINIB = extern struct {
    almatr: ATR, // アラーム通知属性
    exinf: EXINF, // 通知ハンドラの拡張情報
    nfyhdr: NFYHDR, // 通知ハンドラの起動番地
};

///
///  アラーム通知管理ブロック
///
pub const ALMCB = extern struct {
    p_alminib: *const ALMINIB, // 初期化ブロックへのポインタ
    almsta: bool, // アラーム通知の動作状態
    tmevtb: TMEVTB, // タイムイベントブロック
};

///
///  アラーム通知に関するコンフィギュレーションデータの取り込み
///
pub const ExternAlmCfg = struct {
    ///
    ///  アラーム通知IDの最大値
    ///
    pub extern const _kernel_tmax_almid: ID;

    ///
    ///  アラーム通知初期化ブロック（スライス）
    ///
    pub extern const _kernel_alminib_table: [100]ALMINIB;

    ///
    ///  アラーム通知管理ブロックのエリア
    ///
    // Zigの制限事項の回避：十分に大きいサイズの配列とする
    pub extern var _kernel_almcb_table: [100]ALMCB;
};

///
///  アラーム通知IDの最大値
///
fn maxAlmId() ID {
    return @intCast(TMIN_ALMID + cfg._kernel_alminib_table.len - 1);
}

///
///  アラーム通知の数
///
fn numOfAlm() usize {
    return @intCast(cfg._kernel_tmax_almid - TMIN_ALMID + 1);
}

///
///  アラーム通知IDからアラーム通知管理ブロックを取り出すための関数
///
fn indexAlm(almid: ID) usize {
    return @intCast(almid - TMIN_ALMID);
}
fn checkAndGetAlmCB(almid: ID) ItronError!*ALMCB {
    try checkId(TMIN_ALMID <= almid and almid <= cfg._kernel_tmax_almid);
    return &cfg._kernel_almcb_table[indexAlm(almid)];
}

///
///  アラーム通知機能の初期化
///
pub fn initialize_alarm() void {
    for (cfg._kernel_almcb_table[0..numOfAlm()], 0..) |*p_almcb, i| {
        p_almcb.p_alminib = &cfg._kernel_alminib_table[i];
        p_almcb.almsta = false;
        p_almcb.tmevtb.callback = callAlarm;
        p_almcb.tmevtb.arg = @intFromPtr(p_almcb);
    }
}

///
///  アラーム通知の動作開始
///
pub fn sta_alm(almid: ID, almtim: RELTIM) ItronError!void {
    traceLog("staAlmEnter", .{ almid, almtim });
    errdefer |err| traceLog("staAlmLeave", .{err});
    try checkContextUnlock();
    const p_almcb = try checkAndGetAlmCB(almid);
    try checkParameter(validRelativeTime(almtim));
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_almcb.almsta) {
            tmevtb_dequeue(&p_almcb.tmevtb);
        } else {
            p_almcb.almsta = true;
        }
        tmevtb_enqueue_reltim(&p_almcb.tmevtb, almtim);
    }
    traceLog("staAlmLeave", .{null});
}

///
///  アラーム通知の動作停止
///
pub fn stp_alm(almid: ID) ItronError!void {
    traceLog("stpAlmEnter", .{almid});
    errdefer |err| traceLog("stpAlmLeave", .{err});
    try checkContextUnlock();
    const p_almcb = try checkAndGetAlmCB(almid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_almcb.almsta) {
            p_almcb.almsta = false;
            tmevtb_dequeue(&p_almcb.tmevtb);
        }
    }
    traceLog("stpAlmLeave", .{null});
}

///
///  アラーム通知の状態参照
///
pub fn ref_alm(almid: ID, pk_ralm: *T_RALM) ItronError!void {
    traceLog("refAlmEnter", .{ almid, pk_ralm });
    errdefer |err| traceLog("refAlmLeave", .{ err, pk_ralm });
    try checkContextTaskUnlock();
    const p_almcb = try checkAndGetAlmCB(almid);
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        if (p_almcb.almsta) {
            pk_ralm.almstat = TALM_STA;
            pk_ralm.lefttim = tmevt_lefttim(&p_almcb.tmevtb);
        } else {
            pk_ralm.almstat = TALM_STP;
        }
    }
    traceLog("refAlmLeave", .{ null, pk_ralm });
}

///
///  アラーム通知起動ルーチン
///
fn callAlarm(arg: usize) void {
    const p_almcb = @as(*ALMCB, @ptrFromInt(arg));

    // アラーム通知を停止状態にする．
    p_almcb.almsta = false;

    // 通知ハンドラを，CPUロック解除状態で呼び出す．
    target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

    traceLog("alarmEnter", .{p_almcb});
    p_almcb.p_alminib.nfyhdr(p_almcb.p_alminib.exinf);
    traceLog("alarmLeave", .{p_almcb});

    if (!target_impl.mpcore_kernel_impl.core_kernel_impl.senseLock()) {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
    }
}

///
///  アラーム通知の生成（静的APIの処理）
///
pub fn cre_alm(comptime calm: T_CALM) ItronError!ALMINIB {
    // almatrが無効の場合（E_RSATR）［NGKI2491］［NGKI3423］［NGKI3424］
    //（TA_NULLでない場合）
    try checkValidAtr(calm.almatr, TA_NULL);

    // アラーム通知初期化ブロックの生成
    return ALMINIB{
        .almatr = calm.almatr | notify.genFlag(calm.nfyinfo),
        .exinf = notify.genExinf(calm.nfyinfo),
        .nfyhdr = notify.genHandler(calm.nfyinfo),
    };
}

///
///  アラーム通知に関するコンフィギュレーションデータの生成（静的APIの
///  処理）
///
pub fn ExportAlmCfg(comptime alminib_table: []ALMINIB) type {
    // チェック処理用の定義の生成
    exportCheck(@sizeOf(ALMINIB), "sizeof_ALMINIB");
    exportCheck(@offsetOf(ALMINIB, "almatr"), "offsetof_ALMINIB_almatr");
    exportCheck(@offsetOf(ALMINIB, "exinf"), "offsetof_ALMINIB_exinf");
    exportCheck(@offsetOf(ALMINIB, "nfyhdr"), "offsetof_ALMINIB_nfyhdr");

    const tnum_alm = alminib_table.len;

    return struct {
        pub export const _kernel_tmax_almid: ID = tnum_alm;

        // Zigの制限の回避：BIND_CFG != nullの場合に，サイズ0の配列が
        // 出ないようにする
        pub export const _kernel_alminib_table =
            if (option.BIND_CFG == null or tnum_alm > 0)
            alminib_table[0..tnum_alm].*
        else
            [1]ALMINIB{.{
                .almatr = 0,
                .exinf = 0,
                .nfyhdr = 0,
            }};

        pub export var _kernel_almcb_table: [
            if (option.BIND_CFG == null or tnum_alm > 0) tnum_alm else 1
        ]ALMCB = undefined;
    };
}
