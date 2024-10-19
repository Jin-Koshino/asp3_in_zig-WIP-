# asp3_in_zig
TOPPERS/ASP3 Kernel written in Zig Programming Language

このレポジトリは、TOPPERS Projectのレポジトリ[asp3_in_zig](https://github.com/toppers/asp3_in_zig)からJin-Koshinoがforkしたものです。
masterブランチのコミットは変更作業が完了していないため、ビルド時にエラーが発生します。
現在サンプルプログラムを実行可能なコミットは、タグ"v0.9.1-ct11mpcore"が付けられたコミットです。ct11mpcoreをターゲットとした場合にのみサンプルプログラムを実行可能です。

ビルド&実行方法（例）

    % mkdir OBJ-ARM
    % cd OBJ-ARM
    % ../configure.rb -T ct11mpcore_gcc -O "-DTOPPERS_USE_QEMU"
    % make
    % qemu-system-arm -M realview-eb-mpcore -semihosting -m 128M -nographic -kernel asp

Zigのコンパイラは，Release 0.9.1を利用してください。古い版では動作しません。最新版で動作するとは限りません。
また、現時点で対応しているターゲットはct11mpcoreのみで、開発段階のためサンプルプログラム以外の動作は未確認です。

その他の依存しているソフトウェアの動作確認バージョンは，次の通りです。

    arm-none-eabi-gcc      9.3.1 20200408
    arm-none-eabi-objcopy  2.34.0.20200428
    tecsgen                1.7.0
    ruby                   2.6.3p62
    make                   GNU Make 4.3
    qemu-system-arm        version 6.2.0(Debian 1:6.2+dfsg-2ubuntu6.21)

## 利用条件

このレポジトリに含まれるプログラムの利用条件は，[TOPPERSライセンス](https://www.toppers.jp/license.html)です。

## 参考情報

- 小南さんが，以下のページに，関連するソフトウェアに関する情報を詳細に記述くださっています。

  https://github.com/ykominami/asp3_in_zig/blob/master/README.md
