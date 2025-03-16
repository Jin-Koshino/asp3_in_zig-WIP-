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
///  CPU例外管理機能
///
const kernel_impl = @import("kernel_impl.zig");
///usingnamespace task;
const task = kernel_impl.task;
///usingnamespace check;
const check = kernel_impl.check;

////
const zig = kernel_impl.zig;
const t_stddef = zig.t_stddef;

const EXCNO = zig.EXCNO;
const target_impl = kernel_impl.target_impl;
const ATR = t_stddef.ATR;
const EXCHDR = zig.EXCHDR;
const cfg = kernel_impl.cfg;
const traceLog = kernel_impl.traceLog;
const startup = kernel_impl.startup;
const T_DEXC = zig.T_DEXC;
const ItronError = t_stddef.ItronError;

const checkParameter = check.checkParameter;
const checkValidAtr = check.checkValidAtr;
const exco = kernel_impl.exco;

const exportCheck = kernel_impl.exportCheck;
////

///
///  CPU例外ハンドラ番号の範囲の判定
///
pub fn validExcnoDefExc(excno: EXCNO) bool {
    if (@hasDecl(target_impl, "validExcnoDefExc")) {
        return target_impl.mpcore_kernel_impl.core_kernel_impl.validExcnoDefExc(excno);
    } else {
        return target_impl.mpcore_kernel_impl.core_kernel_impl.validExcno(excno);
    }
}

///
///  ターゲット依存のCPU例外ハンドラ属性
///
const TARGET_EXCATR =
    if (@hasDecl(target_impl, "TARGET_EXCATR")) target_impl.TARGET_EXCATR else 0;

///
///  CPU例外ハンドラ初期化ブロック
///
pub const EXCINIB =
    if (@hasDecl(target_impl.mpcore_kernel_impl.core_kernel_impl, "EXCINIB")) target_impl.mpcore_kernel_impl.core_kernel_impl.EXCINIB else struct {
    excno: EXCNO, // CPU例外ハンドラ番号
    excatr: ATR, // CPU例外ハンドラ属性
    exchdr: EXCHDR, // CPU例外ハンドラの先頭番地
};

///
///  CPU例外ハンドラ初期化ブロックの取り込み
///
pub const ExternExcIniB =
    if (@hasDecl(target_impl.mpcore_kernel_impl.core_kernel_impl, "ExternExcIniB")) target_impl.mpcore_kernel_impl.core_kernel_impl.ExternExcIniB else struct {
    ///
    ///  CPU例外ハンドラ初期化ブロック（スライス）
    ///
    pub extern const _kernel_excinib_table: []EXCINIB;
};

///
///  CPU例外管理機能の初期化
///
pub fn initialize_exception() void {
    if (@hasDecl(target_impl.mpcore_kernel_impl.core_kernel_impl, "initialize_exception")) {
        target_impl.mpcore_kernel_impl.core_kernel_impl.initialize_exception();
    } else {
        // 標準的な初期化処理
        for (cfg._kernel_excinib_table) |*p_excinib| {
            target_impl.define_exc(p_excinib.excno, p_excinib.excatr, p_excinib.exchdr);
        }
    }
}

///
///  CPU例外発生時のディスパッチ保留状態の参照
///
///  CPU例外ハンドラ中でenadspが変化することはないため，CPU例外が発生
///  した時のenadspを保存しておく必要はない．
///
pub fn xsns_dpn(p_excinf: *anyopaque) bool {
    traceLog("xSnsDpnEnter", .{p_excinf});
    const state = !(startup.kerflg and target_impl.mpcore_kernel_impl.core_kernel_impl.exc_sense_intmask(p_excinf) and task.enadsp and task.p_runtsk != null);
    traceLog("xSnsDpnLeave", .{state});
    return state;
}

///
///  CPU例外ハンドラの定義（静的APIの処理）
///
pub fn def_exc(excno: EXCNO, dexc: T_DEXC) ItronError!EXCINIB {
    // excnoが有効範囲外の場合（E_PAR）［NGKI3134］
    try checkParameter(validExcnoDefExc(excno));

    // excatrが無効の場合（E_RSATR）［NGKI3131］［NGKI5178］［NGKI3123］
    //（TARGET_EXCATR以外のビットがセットされている場合）
    try checkValidAtr(dexc.excatr, TARGET_EXCATR);

    // ターゲット依存のエラーチェック
    if (@hasDecl(target_impl, "checkDefExc")) {
        try target_impl.checkDefExc(exco, dexc);
    }

    // CPU例外ハンドラ初期化ブロックを返す
    return if (@hasDecl(target_impl, "buildExcIniB"))
        target_impl.buildExcIniB(excno, dexc)
    else
        EXCINIB{
            .excno = excno,
            .excatr = dexc.excatr,
            .exchdr = dexc.exchdr,
        };
}

///
///  CPU例外ハンドラ初期化ブロックの生成（静的APIの処理）
///
pub fn ExportExcIniB(comptime excinib_table: []EXCINIB) type {
    // チェック処理用の定義の生成
    exportCheck(@sizeOf(EXCINIB), "sizeof_EXCINIB");
    exportCheck(@sizeOf(EXCNO), "sizeof_EXCNO");
    exportCheck(@sizeOf(EXCHDR), "sizeof_EXCHDR");
    exportCheck(@offsetOf(EXCINIB, "excno"), "offsetof_EXCINIB_excno");
    exportCheck(@offsetOf(EXCINIB, "exchdr"), "offsetof_EXCINIB_exchdr");

    return struct {
        export const _kernel_excinib_table = excinib_table;
    };
}
