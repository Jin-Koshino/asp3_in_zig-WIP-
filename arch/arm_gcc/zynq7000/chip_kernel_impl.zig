///
///  カーネルのチップ依存部（Zynq7000用）
///
const kernel_impl = @import("../../../kernel/kernel_impl.zig");

///
///  デフォルトの非タスクコンテキスト用のスタック領域の定義
///
pub const DEFAULT_ISTKSZ = 0x2000;

///
///  ARM Cortex-A9 GTC Errataへの対策を実施
///
pub const ARM_CA9_GTC_ERRATA = true;

///
///  MPCore依存部
///
pub const mpcore_kernel_impl = @import("../common/mpcore_kernel_impl.zig");

////
const mpcore_initialize = mpcore_kernel_impl.mpcore_initialize;
const mpcore_terminate = mpcore_kernel_impl.mpcore_terminate;
////

///
///  L2キャッシュコントローラ（PL310）の操作ライブラリ
///
const pl310 = @import("../common/pl310.zig");

///
///  チップ依存の初期化
///
pub fn chip_initialize() void {
    // MPCore依存の初期化
    mpcore_initialize();

    // L2キャッシュコントローラ（PL310）の初期化
    pl310.initialize(0x0, ~@as(u32, 0x0));
}

///
///  チップ依存の終了処理
///
pub fn chip_terminate() void {
    // MPCore依存の終了処理
    mpcore_terminate();
}
