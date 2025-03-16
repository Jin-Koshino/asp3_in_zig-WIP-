///
///  TOPPERS/ASP Kernel
///      Toyohashi Open Platform for Embedded Real-Time Systems/
///      Advanced Standard Profile Kernel
///
///  Copyright (C) 2006-2020 by Embedded and Real-Time Systems Laboratory
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
///  kernel.zigのターゲット依存部
///  （CT11MPCore＋タイマドライバシミュレータ用）
///
///
///  コンパイルオプションによるマクロ定義の取り込み
///
const opt = @cImport({});
const HRT_CONFIG1 = @hasDecl(opt, "HRT_CONFIG1");
const HRT_CONFIG2 = @hasDecl(opt, "HRT_CONFIG2");
const HRT_CONFIG3 = @hasDecl(opt, "HRT_CONFIG3");

///
///  コアで共通な定義
///
const core_kernel = @import("../../arch/arm_gcc/common/core_kernel.zig");

///
///  サポートできる機能の定義
///
pub const TOPPERS_SUPPORT_ENA_INT = true; // ena_int
pub const TOPPERS_SUPPORT_DIS_INT = true; // dis_int
pub const TOPPERS_SUPPORT_CLR_INT = true; // clr_int
pub const TOPPERS_SUPPORT_RAS_INT = true; // ras_int
pub const TOPPERS_SUPPORT_PRB_INT = true; // prb_int
pub const TOPPERS_SUPPORT_OVRHDR = true;

///
///  高分解能タイマに関するパラメータ
///
///
///  1μ秒毎にカウントアップする32ビットタイマ
///
const hrt_config1 = struct {
    // TCYC_HRTCNTは定義しない．

    // 高分解能タイマのカウント値の進み幅
    pub const TSTEP_HRTCNT = 1;
};

///
///  10μ毎にカウントアップする16ビットタイマ
///
const hrt_config2 = struct {
    // 高分解能タイマのタイマ周期
    pub const TCYC_HRTCNT = 0x10000 * 10;

    // 高分解能タイマのカウント値の進み幅
    pub const TSTEP_HRTCNT = 10;
};

///
///  1μ秒毎にカウントアップする64ビットタイマ
///
const hrt_config3 = struct {
    // TCYC_HRTCNTは定義しない．

    // 高分解能タイマのカウント値の進み幅
    pub const TSTEP_HRTCNT = 1;
};

pub usingnamespace if (HRT_CONFIG1) hrt_config1 else if (HRT_CONFIG2) hrt_config2 else if (HRT_CONFIG3) hrt_config3 else @compileError("");

///
///  割込み優先度の範囲
///
pub const TMIN_INTPRI = -15; // 割込み優先度の最小値（最高値）
pub const TMAX_INTPRI = -1; // 割込み優先度の最大値（最低値）

///
///  アプリケーションに直接見せる定義
///
pub const publish = struct {
    ///
    ///  コアで共通な定義の取り込み
    ///
    pub usingnamespace core_publish;
};
