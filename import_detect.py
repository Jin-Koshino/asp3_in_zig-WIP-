#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import os
import re
import sys

# Zigのコメントをざっくり除去する:
#   - 行コメント // ...（文字列内は厳密には未対応だが実用上はこれで十分）
#   - ブロックコメント /* ... */（ネストは未対応）
RE_LINE_COMMENT = re.compile(r'//.*?$' , re.MULTILINE)
RE_BLOCK_COMMENT = re.compile(r'/\*.*?\*/', re.DOTALL)

# @import("...") の第1引数（文字列リテラル）のみを抽出
#   @import ("std")
#   @import("kernel/root.zig")
RE_IMPORT_STRING = re.compile(r'@import\s*\(\s*"([^"\n\r]*)"\s*\)')

def strip_comments(src: str) -> str:
    no_block = RE_BLOCK_COMMENT.sub("", src)
    no_line = RE_LINE_COMMENT.sub("", no_block)
    return no_line

def find_imports_in_file(path: str):
    try:
        with open(path, "r", encoding="utf-8") as f:
            src = f.read()
    except Exception as e:
        print(f"# WARN: cannot read {path}: {e}", file=sys.stderr)
        return []

    clean = strip_comments(src)
    return RE_IMPORT_STRING.findall(clean)

def main():
    parser = argparse.ArgumentParser(
        description="Recursively scan .zig files and list (file, @import argument) pairs."
    )
    parser.add_argument("directory", help="root directory to scan")
    args = parser.parse_args()

    root = os.path.abspath(args.directory)
    if not os.path.isdir(root):
        print(f"ERROR: not a directory: {root}", file=sys.stderr)
        sys.exit(1)

    for dirpath, dirnames, filenames in os.walk(root):
        # 隠しディレクトリ等をスキップしたい場合は必要に応じてここで dirnames をフィルタ
        for name in filenames:
            if not name.endswith(".zig") or name == "root.zig":
                continue
            path = os.path.join(dirpath, name)
            imports = find_imports_in_file(path)
            if not imports:
                continue
            # .zigファイルとインポート引数の組をターミナルに出力
            # 出力形式: <file_path>\t<import_arg>
            for imp in imports:
                # stdのインポートは出力対象から除外
                if imp == "std" or imp == "builtin":
                    continue
                print(f"{path}\t{imp}")

if __name__ == "__main__":
    main()