///
///  TOPPERS/ASP Kernel
///      Toyohashi Open Platform for Embedded Real-Time Systems/
///      Advanced Standard Profile Kernel
///
///  Copyright (C) 2006-2021 by Embedded and Real-Time Systems Laboratory
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
///  カーネルの割込みコントローラ依存部（GIC用）
///
const kernel_impl = @import("../../../kernel/kernel_impl.zig");

////
const zig = kernel_impl.zig;
const t_stddef = zig.t_stddef;

const option = kernel_impl.option;
const isTrue = kernel_impl.isTrue;
const target_impl = kernel_impl.target_impl;
const TMAX_INTPRI = zig.TMAX_INTPRI;
const TMIN_INTPRI = zig.TMIN_INTPRI;
const PRI = t_stddef.PRI;
const sil = kernel_impl.sil;
const INTNO = zig.INTNO;
const cfg = kernel_impl.cfg;
const ATR = t_stddef.ATR;
const assert = t_stddef.assert;
const TA_EDGE = zig.TA_EDGE;
const TA_ENAINT = zig.TA_ENAINT;
////

///
///  コンフィギュレーションオプションの取り込み
///
const GIC_TNUM_INTNO = option.target.GIC_TNUM_INTNO;
const GICC_BASE = option.target.GICC_BASE;
const GICD_BASE = option.target.GICD_BASE;
const GIC_SUPPORT_DISABLE_SGI = isTrue(option.target, "GIC_SUPPORT_DISABLE_SGI");
const GIC_ARM11MPCORE = isTrue(option.target, "GIC_ARM11MPCORE");

///
///  ターゲット依存の定義の取り込み
///
const GIC_PL390_ERRATA = isTrue(target_impl, "GIC_PL390_ERRATA");

///
///  用いるライブラリ
///
const arm = @import("arm.zig");

//
//  ARMバージョンのチェック
//
comptime {
    if (!arm.isEnabled(arm.Feature.has_v6)) {
        @compileError("gic_kernel_impl.zig supports ARMv6 or later.");
    }
}

///
///  割込み番号の最小値と最大値
///
pub const GIC_TMIN_INTNO = 0;
pub const GIC_TMAX_INTNO = GIC_TNUM_INTNO - 1;

///
///  割込み番号の定義
///
const GIC_INTNO_SGI0 = 0;
const GIC_INTNO_PPI0 = 16;
const GIC_INTNO_SPI0 = 32;

///
///  割込み優先度の操作
///
///  割込み優先度の内部表現は，u32型で表し，0が最高優先度で，値が大き
///  いほど優先度が下がるものとする．GICのレジスタ構成と整合させるため
///  に，優先度の段数が256段階の時にあわせて表す．
///
const GIC_PRI_LEVEL = TMAX_INTPRI - TMIN_INTPRI + 2;
const GIC_PRI_SHIFT = switch (GIC_PRI_LEVEL) {
    16 => 4,
    32 => 3,
    64 => 2,
    128 => 1,
    256 => 0,
    else => @compileError(""),
};
const GIC_PRI_MASK = switch (GIC_PRI_LEVEL) {
    16 => 0x0f,
    32 => 0x1f,
    64 => 0x3f,
    128 => 0x7f,
    256 => 0xff,
    else => @compileError(""),
};

/// 割込み優先度マスクの外部表現への変換
pub fn externalIpm(pri: u32) PRI {
    return @as(PRI, @intCast((pri >> GIC_PRI_SHIFT))) - (GIC_PRI_LEVEL - 1);
}

/// 割込み優先度マスクの内部表現への変換
pub fn internalIpm(ipm: PRI) u32 {
    return @as(u32, @intCast(ipm + GIC_PRI_LEVEL - 1)) << GIC_PRI_SHIFT;
}

///
///  CPUインタフェース関連の定義
///
const GICC_CTLR = @as(*u32, @ptrFromInt(GICC_BASE + 0x00));
const GICC_PMR = @as(*u32, @ptrFromInt(GICC_BASE + 0x04));
const GICC_BPR = @as(*u32, @ptrFromInt(GICC_BASE + 0x08));
const GICC_IAR = @as(*u32, @ptrFromInt(GICC_BASE + 0x0c));
const GICC_EOIR = @as(*u32, @ptrFromInt(GICC_BASE + 0x10));
const GICC_RPR = @as(*u32, @ptrFromInt(GICC_BASE + 0x14));
const GICC_HPPIR = @as(*u32, @ptrFromInt(GICC_BASE + 0x18));

///
///  CPUインタフェース制御レジスタ（GICC_CTLR）の設定値（GICv1でセキュ
///  リティ拡張がない場合）
///
const GICC_CTLR_DISABLE = 0x00;
const GICC_CTLR_ENABLE = 0x01;

///
///  ディストリビュータ関連の定義
///
const GICD_CTLR = @as(*u32, @ptrFromInt(GICD_BASE + 0x000));
const GICD_TYPER = @as(*u32, @ptrFromInt(GICD_BASE + 0x004));
const GICD_IIDR = @as(*u32, @ptrFromInt(GICD_BASE + 0x008));
fn GICD_IGROUPR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x080 + n * 4));
}
fn GICD_ISENABLER(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x100 + n * 4));
}
fn GICD_ICENABLER(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x180 + n * 4));
}
fn GICD_ISPENDR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x200 + n * 4));
}
fn GICD_ICPENDR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x280 + n * 4));
}
fn GICD_ISACTIVER(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x300 + n * 4));
}
fn GICD_ICACTIVER(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x380 + n * 4));
}
fn GICD_IPRIORITYR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x400 + n * 4));
}
fn GICD_ITARGETSR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0x800 + n * 4));
}
fn GICD_ICFGR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0xc00 + n * 4));
}
fn GICD_NSCAR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0xe00 + n * 4));
}
const GICD_SGIR = @as(*u32, @ptrFromInt(GICD_BASE + 0xf00));
fn GICD_CPENDSGIR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0xf10 + n * 4));
}
fn GICD_SPENDSGIR(n: c_uint) *u32 {
    return @as(*u32, @ptrFromInt(GICD_BASE + 0xf20 + n * 4));
}

///
///  ディストリビュータ制御レジスタ（GICD_CTLR）の設定値
///
const GICD_CTLR_DISABLE = 0x00;
const GICD_CTLR_ENABLE = 0x01;

///
///  割込みコンフィギュレーションレジスタ（GICD_ICFGRn）の設定値
///
///  第1ビットは，ARM11 MPCoreおよびGICの早い時期の実装では割込みの通
///  知先プロセッサを設定するために使用されている．
///
pub const GICD_ICFGRn_LEVEL = 0x00;
pub const GICD_ICFGRn_EDGE = 0x02;
pub const GICD_ICFGRn_N_N = if (GIC_ARM11MPCORE) 0x00 else @compileError("");
pub const GICD_ICFGRn_1_N = if (GIC_ARM11MPCORE) 0x01 else @compileError("");

///
///  CPUインタフェースの操作
///
///
///  割込み優先度マスクを設定（priは内部表現）
///
fn gicc_set_priority(pri: u32) void {
    sil.swrw_mem(GICC_PMR, pri);
}

///
///  割込み優先度マスクを取得（内部表現で返す）
///
fn gicc_get_priority() u32 {
    return sil.rew_mem(GICC_PMR);
}

///
///  CPUインタフェースの初期化
///
pub fn gicc_initialize() void {
    // CPUインタフェースをディスエーブル
    sil.wrw_mem(GICC_CTLR, GICC_CTLR_DISABLE);

    // 割込み優先度マスクを最低優先度に設定
    gicc_set_priority((GIC_PRI_LEVEL - 1) << GIC_PRI_SHIFT);

    // 割込み優先度の全ビット有効に
    sil.wrw_mem(GICC_BPR, 0);

    // アクティブな割込みがあれば，EOIによりクリアする
    sil.wrw_mem(GICC_EOIR, sil.rew_mem(GICC_IAR));

    // CPUインタフェースをイネーブル
    sil.wrw_mem(GICC_CTLR, GICC_CTLR_ENABLE);
}

///
///  CPUインタフェースの終了処理
///
pub fn gicc_terminate() void {
    sil.wrw_mem(GICC_CTLR, GICC_CTLR_DISABLE);
}

///
///  ディストリビュータの操作
///
///
///  割込み禁止（割込みイネーブルのクリア）
///
fn gicd_disable_int(intno: INTNO) void {
    sil.swrw_mem(GICD_ICENABLER(intno / 32), @as(u32, 1) << @as(u5, @intCast(intno % 32)));
}

///
///  割込み許可（割込みイネーブルのセット）
///
fn gicd_enable_int(intno: INTNO) void {
    sil.swrw_mem(GICD_ISENABLER(intno / 32), @as(u32, 1) << @as(u5, @intCast(intno % 32)));
}

///
///  割込みペンディングのクリア
///
fn gicd_clear_pending(intno: INTNO) void {
    sil.swrw_mem(GICD_ICPENDR(intno / 32), @as(u32, 1) << @as(u5, @intCast(intno % 32)));
}

///
///  割込みペンディングのセット
///
fn gicd_set_pending(intno: INTNO) void {
    sil.swrw_mem(GICD_ISPENDR(intno / 32), @as(u32, 1) << @as(u5, @intCast(intno % 32)));
}

///
///  割込みペンディングのチェック
///
fn gicd_probe_pending(intno: INTNO) bool {
    return (sil.rew_mem(GICD_ISPENDR(intno / 32)) &
        @as(u32, 1) << @as(u5, @intCast(intno % 32))) != 0;
}

///
///  ソフトウェア生成割込み（SGI）の生成
///
fn gicd_raise_sgi(intno: INTNO) void {
    sil.swrw_mem(GICD_SGIR, (0x02000000 | intno));
}

///
///  割込みのコンフィグレーション
///
pub fn gicd_config(intno: INTNO, conf: u32) void {
    if (intno >= GIC_INTNO_PPI0) {
        var reg = sil.rew_mem(GICD_ICFGR(intno / 16));
        var shift: c_uint = (intno % 16) * 2;
        reg &= ~(@as(u32, 0x03) << @as(u5, @intCast(shift)));
        reg |= (conf << @as(u5, @intCast(shift)));
        sil.wrw_mem(GICD_ICFGR(intno / 16), reg);
    }
}

///
///  割込み要求ラインに対する割込み優先度の設定（priは内部表現）
///
pub fn gicd_set_priority(intno: INTNO, pri: u32) void {
    var reg = sil.rew_mem(GICD_IPRIORITYR(intno / 4));
    var shift: c_uint = (intno % 4) * 8;
    reg &= ~(@as(u32, 0xff) << @as(u5, @intCast(shift)));
    reg |= (pri << @as(u5, @intCast(@as(u5, @intCast(shift)))));
    sil.wrw_mem(GICD_IPRIORITYR(intno / 4), reg);
}

///
///  割込みターゲットプロセッサの設定
///
///  affinityは，ターゲットとするプロセッサを表すビットのビット毎論理和
///  で指定する．
///        プロセッサ0 : 0x01
///        プロセッサ1 : 0x02
///        プロセッサ2 : 0x04
///        プロセッサ3 : 0x08
///
pub fn gicd_set_target(intno: INTNO, affinity: u32) void {
    var reg = sil.rew_mem(GICD_ITARGETSR(intno / 4));
    var shift: c_uint = (intno % 4) * 8;
    reg &= ~(@as(u32, 0xff) << @as(u5, @intCast(shift)));
    reg |= (affinity << @as(u5, @intCast(shift)));
    sil.wrw_mem(GICD_ITARGETSR(intno / 4), reg);
}

///
///  ディストリビュータの初期化
///
pub fn gicd_initialize() void {
    var i: c_uint = undefined;

    // ディストリビュータをディスエーブル
    sil.wrw_mem(GICD_CTLR, GICD_CTLR_DISABLE);

    // すべての割込みを禁止
    i = 0;
    while (i < (GIC_TNUM_INTNO + 31) / 32) : (i += 1) {
        sil.wrw_mem(GICD_ICENABLER(i), 0xffffffff);
    }

    // すべての割込みペンディングをクリア
    i = 0;
    while (i < (GIC_TNUM_INTNO + 31) / 32) : (i += 1) {
        sil.wrw_mem(GICD_ICPENDR(i), 0xffffffff);
    }

    // すべての割込みを最低優先度に設定
    i = 0;
    while (i < (GIC_TNUM_INTNO + 3) / 4) : (i += 1) {
        sil.wrw_mem(GICD_IPRIORITYR(i), 0xffffffff);
    }

    // すべての共有ペリフェラル割込みのターゲットをプロセッサ0に設定
    i = GIC_INTNO_SPI0 / 4;
    while (i < (GIC_TNUM_INTNO + 3) / 4) : (i += 1) {
        sil.wrw_mem(GICD_ITARGETSR(i), 0x01010101);
    }

    // すべてのペリフェラル割込みをレベルトリガに設定
    i = GIC_INTNO_PPI0 / 16;
    while (i < (GIC_TNUM_INTNO + 15) / 16) : (i += 1) {
        if (GIC_ARM11MPCORE) {
            sil.wrw_mem(GICD_ICFGR(i), 0x55555555);
        } else {
            sil.wrw_mem(GICD_ICFGR(i), 0x00000000);
        }
    }

    // ディストリビュータをイネーブル
    sil.wrw_mem(GICD_CTLR, GICD_CTLR_ENABLE);
}

///
///  ディストリビュータの終了処理
///
pub fn gicd_terminate() void {
    sil.wrw_mem(GICD_CTLR, GICD_CTLR_DISABLE);
}

///
///  割込み番号の範囲の判定
///
pub fn validIntno(intno: INTNO) bool {
    return GIC_TMIN_INTNO <= intno and intno <= GIC_TMAX_INTNO;
}

///
///  割込みハンドラ番号の範囲の判定
///
pub const validInhno = validIntno;

///
///  割込み要求ラインのための標準的な初期化情報を生成する
///
pub const USE_INTINIB_TABLE = true;

///
///  割込み要求ライン設定テーブルを生成する
///
pub const USE_INTCFG_TABLE = true;

///
///  ターゲット非依存部に提供する関数
///
///
///  割込み属性の設定のチェック
///
pub fn checkIntnoCfg(intno: INTNO) bool {
    return cfg._kernel_intcfg_table[intno];
}

///
///  割込み優先度マスクの設定
///
pub fn setIpm(intpri: PRI) void {
    gicc_set_priority(internalIpm(intpri));
}

///
///  割込み優先度マスクの参照
///
pub fn getIpm() PRI {
    return externalIpm(gicc_get_priority());
}

///
///  割込み要求禁止フラグが操作できる割込み番号の範囲の判定
///
pub fn validIntnoDisInt(intno: INTNO) bool {
    if (GIC_SUPPORT_DISABLE_SGI) {
        return validIntno(intno);
    } else {
        return GIC_INTNO_PPI0 <= intno and intno <= GIC_TMAX_INTNO;
    }
}

///
///  割込み要求禁止フラグのセット
///
pub fn disableInt(intno: INTNO) void {
    gicd_disable_int(intno);
}

///
///  割込み要求禁止フラグのクリア
///
pub fn enableInt(intno: INTNO) void {
    gicd_enable_int(intno);
}

///
///  割込み要求がクリアできる割込み番号の範囲の判定
///
pub fn validIntnoClrInt(intno: INTNO) bool {
    return GIC_INTNO_PPI0 <= intno and intno <= GIC_TMAX_INTNO;
}

///
///  割込み要求がクリアできる状態か？
///
pub fn checkIntnoClear(intno: INTNO) bool {
    _ = intno;
    return true;
}

///
///  割込み要求のクリア
///
pub fn clearInt(intno: INTNO) void {
    gicd_clear_pending(intno);
}

///
///  割込みが要求できる状態か？
///
pub fn checkIntnoRaise(intno: INTNO) bool {
    _ = intno;
    return true;
}

///
///  割込みの要求
///
pub fn raiseInt(intno: INTNO) void {
    if (intno < GIC_INTNO_PPI0) {
        gicd_raise_sgi(intno);
    } else {
        gicd_set_pending(intno);
    }
}

///
///  割込み要求のチェック
///
pub fn probeInt(intno: INTNO) bool {
    return gicd_probe_pending(intno);
}

///
///  割込み要求ラインの属性の設定
///
///  ASPカーネルでの利用を想定して，パラメータエラーはアサーションで
///  チェックしている．
///
fn config_int(intno: INTNO, intatr: ATR, intpri: PRI) void {
    assert(validIntno(intno), null);
    assert(TMIN_INTPRI <= intpri and intpri <= TMAX_INTPRI, intpri);

    // 割込みを禁止
    //
    // 割込みを受け付けたまま，レベルトリガ／エッジトリガの設定や，割
    // 込み優先度の設定を行うのは危険なため，割込み属性にかかわらず，
    // 一旦マスクする．
    disableInt(intno);

    // 割込みをコンフィギュレーション
    if ((intatr & TA_EDGE) != 0) {
        if (GIC_ARM11MPCORE) {
            gicd_config(intno, GICD_ICFGRn_EDGE | GICD_ICFGRn_1_N);
        } else {
            gicd_config(intno, GICD_ICFGRn_EDGE);
        }
        clearInt(intno);
    } else {
        if (GIC_ARM11MPCORE) {
            gicd_config(intno, GICD_ICFGRn_LEVEL | GICD_ICFGRn_1_N);
        } else {
            gicd_config(intno, GICD_ICFGRn_LEVEL);
        }
    }

    // 割込み優先度とターゲットプロセッサを設定
    gicd_set_priority(intno, internalIpm(intpri));
    gicd_set_target(intno, @as(u32, 1) << @as(u5, @intCast(arm.get_my_prcidx())));

    // 割込みを許可
    if ((intatr & TA_ENAINT) != 0) {
        enableInt(intno);
    }
}

//
//  割込みハンドラ呼出し前の割込みコントローラ操作
//
//  r4に割込み番号を返す．irc_end_intで用いる情報（割込み発生前の割込
//  み優先度マスク）を，スタックの先頭に保存する．
//
pub fn irc_begin_int() callconv(.Naked) void {
    // r1をGICC_BASEに設定する
    asm volatile (""
        :
        : [gicc_base] "{r1}" (@as(u32, GICC_BASE)),
    );
    if (GIC_PL390_ERRATA) { // GIC 390 Errata 801120への対策
        // r2をGICD_BASEに設定する
        asm volatile (""
            :
            : [gicd_base] "{r2}" (@as(u32, GICD_BASE)),
        );
    }

    // 割込み要因を取得する．
    if (GIC_PL390_ERRATA) { // GIC 390 Errata 801120への対策
        asm volatile (
            \\  ldr r0, [r1, %[offset_hppir]]
            :
            : [offset_hppir] "i" (@intFromPtr(GICC_HPPIR) - GICC_BASE),
        );
    }
    asm volatile (
        \\  ldr r3, [r1, %[offset_iar]]
        \\  lsl r4, r3, #22            // 下位10ビットを取り出す
        \\  lsr r4, r4, #22
        :
        : [offset_iar] "i" (@intFromPtr(GICC_IAR) - GICC_BASE),
    );
    if (GIC_PL390_ERRATA) { // GIC 390 Errata 801120への対策
        asm volatile (
            \\  movw r0, #1023
            \\  cmp r4, r0
            \\  beq .Lirc_begin_int_errata_1
            \\  movw r0, #1022
            \\  cmp r4, r0
            \\  beq .Lirc_begin_int_errata_1
            \\  cmp r3, #0
            \\  bne .Lirc_begin_int_errata_2
            \\  ldr r0, [r2, %[offset_isactiver0]]
            \\  tst r0, #0x01          // 割込み要求があるかチェック
            \\  movweq r4, #1024       // 無効な割込みとみなす
            \\ .Lirc_begin_int_errata_1:
            \\ // 割込み優先度レジスタ0に書き込み
            \\  ldr r0, [r2, %[offset_ipriorityr0]]
            \\  str r0, [r2, %[offset_ipriorityr0]]
            ++ "\n" ++
                arm.asm_data_sync_barrier("r0") ++ "\n" ++
                \\ .Lirc_begin_int_errata_2:
            :
            : [offset_isactiver0] "i" (@intFromPtr(GICD_ISACTIVER(0)) - GICD_BASE),
              [offset_ipriorityr0] "i" (@intFromPtr(GICD_IPRIORITYR(0)) - GICD_BASE),
        );
    }
    asm volatile (
        \\ // 割込み要因の割込み優先度を求め，割込み優先度マスクに設定する．
        \\  ldr r0, [r1, %[offset_rpr]]    // 受け付けた割込みの割込み優先度を取得
        \\  ldr r2, [r1, %[offset_pmr]]    // 割込み発生前の割込み優先度を取得
        \\  str r0, [r1, %[offset_pmr]]    // 新しい割込み優先度マスクをセットする
        ++ "\n" ++
            arm.asm_data_sync_barrier("r0") // 割込み優先度マスクが
        ++ "\n" ++ //     セットされるのを待つ
            \\  str r2, [sp]               // irc_end_intで用いる情報を保存
            \\ // EOIを発行する．
            \\  str r3, [r1, %[offset_eoir]]
            \\
            \\ // r4に割込み番号を入れた状態でリターンする．
            \\  bx lr
        :
        : [offset_pmr] "i" (@intFromPtr(GICC_PMR) - GICC_BASE),
          [offset_eoir] "i" (@intFromPtr(GICC_EOIR) - GICC_BASE),
          [offset_rpr] "i" (@intFromPtr(GICC_RPR) - GICC_BASE),
    );
    //unreachable;
}

//
//  割込みハンドラ呼出し後の割込みコントローラ操作
//
pub fn irc_end_int() callconv(.Naked) void {
    asm volatile (
        \\ // 割込み優先度マスクを元に戻す．
        \\  ldr r2, [sp]           // irc_begin_intで保存した情報を復帰
        \\  str r2, [r1]           // 割込み優先度マスク（GICC_PMR）を元に戻す
        \\  bx lr
        :
        : [gicc_pmr] "{r1}" (@intFromPtr(GICC_PMR)),
    );
    //unreachable;
}

//
//  CPU例外発生前の割込み優先度の取得
//
//  CPU例外の発生で割込み優先度が変わることはないため，現在の割込み優先
//  度を返す．
//
pub fn irc_get_intpri() callconv(.Naked) void {
    asm volatile (
        \\ // 割込み優先度マスクを外部表現に変換して返す．
        \\  ldr r0, [r1]           // 現在の割込み優先度（GICC_PMR）を取得
        \\  asr r0, r0, %[gic_pri_shift]
        \\  sub r0, r0, %[gic_pri_mask]
        \\  bx lr
        :
        : [gic_pri_shift] "n" (@as(u32, GIC_PRI_SHIFT)),
          [gic_pri_mask] "n" (@as(u32, GIC_PRI_MASK)),
          [gicc_pmr] "{r1}" (@intFromPtr(GICC_PMR)),
    );
    //unreachable;
}

//
//  CPU例外ハンドラ呼出し前の割込みコントローラ操作
//
//  irc_end_excで用いる情報（CPU例外発生前の割込み優先度マスク）を，
//  スタックの先頭に保存する．
//
pub fn irc_begin_exc() callconv(.Naked) void {
    asm volatile (
        \\ irc_begin_exc:
        \\ // 割込み優先度マスクを保存する．
        \\  ldr r2, [r1]           // 現在の割込み優先度（GICC_PMR）を取得
        \\  str r2, [sp]           // irc_end_excで用いる情報を保存
        \\  bx lr
        :
        : [gicc_pmr] "{r1}" (@intFromPtr(GICC_PMR)),
    );
    //unreachable;
}

//
//  CPU例外ハンドラ呼出し後の割込みコントローラ操作
//
pub fn irc_end_exc() callconv(.Naked) void {
    asm volatile (
        \\ // 割込み優先度マスクを元に戻す．
        \\  ldr r2, [sp]           // irc_begin_excで保存した情報を復帰
        \\  str r2, [r1]           // 割込み優先度マスク（GICC_PMR）を元に戻す
        \\  bx lr
        :
        : [gicc_pmr] "{r1}" (@intFromPtr(GICC_PMR)),
    );
    //unreachable;
}

///
///  割込み管理機能の初期化
///
pub fn initialize_interrupt() void {
    for (cfg._kernel_intinib_table[0..cfg._kernel_tnum_cfg_intno]) |p_intinib| {
        config_int(p_intinib.intno, p_intinib.intatr, p_intinib.intpri);
    }
}
