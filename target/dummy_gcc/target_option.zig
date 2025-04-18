///
///  コンフィギュレーションオプションのターゲット依存部（ダミーターゲット用）
///
///
///  コンパイルオプションによるマクロ定義の取り込み
///
const opt = @cImport({});

///
///  ターゲットのハードウェア資源の定義
///
const dummy = @import("dummy.zig");

///
///  サンプルプログラム／テストプログラムのための定義
///
pub const _test = struct {};
