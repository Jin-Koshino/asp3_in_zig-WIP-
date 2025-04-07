import os
import re

def path_to_mod_name(path):
    # '../' などを正規化して除去する
    normalized = re.sub(r'^(\.\./)+', '', os.path.normpath(path))
    # 拡張子を除去する
    no_extension = os.path.splitext(normalized)[0]
    # '/'を'_'に置き換える
    slash_replace = no_extension.replace('/', '_')
    # '-'を'_'に置き換える
    dash_replace = slash_replace.replace('-', '_')
    return dash_replace

# 依存関係を抽出する関数
def extract_imports_from_file(filepath):
    imports = []
    import_pattern = re.compile(r'@import\("([^"]+)"\)')

    with open(filepath, 'r', encoding='utf-8') as file:
        for line in file:
            matches = import_pattern.findall(line)
            imports.extend(matches)
    return imports

# フォルダを再帰的に走査し、ファイルごとの依存関係を抽出
def collect_dependencies(root_dir):
    dependencies = {}
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".zig") and "zig-cache" not in dirpath:
                filepath = os.path.join(dirpath, filename)
                imports = extract_imports_from_file(filepath)
                rel_filepath = os.path.relpath(filepath, root_dir)
                dependencies[rel_filepath] = imports
    return dependencies

# 視覚的に分かりやすく依存関係を出力
def print_dependencies(dependencies):
    for file, imports in dependencies.items():
        if imports != []:
            print(f"{file}")
            for imp in imports:
                print(f"  └── {imp}")
            print()

# build.zig用のモジュール登録のための依存関係に変換
def extract_deps_for_buildzig(dependencies):
    deps_for_buildzig = {}
    # 各.zigファイルで，上位階層を経由して@importされているモジュールを抽出
    for file, imports in dependencies.items():
        deps_for_buildzig[file] = []
        for imp in imports:
            # 上位階層を経由して@importされているモジュールを抽出，パスを正規化
            if imp.startswith("../"):
                # 相対パスを絶対パスに変換してから正規化
                imp_from_root = os.path.normpath(os.path.join(os.path.dirname(file), imp))
                deps_for_buildzig[file].append(imp_from_root)
    return deps_for_buildzig

# build.zigへの記述を自動生成
def generate_description_for_buildzig(deps_for_buildzig):
    # @importされるモジュールの登録
    already_declared = []
    for _, imports in deps_for_buildzig.items():
        for imp in imports:
            if imp not in already_declared:
                already_declared.append(imp)
    for imp in already_declared:
        imp_name = path_to_mod_name(imp)
        print(f"const {imp_name}_mod = b.addModule(\"{imp_name}\", .{{.root_source_file = .{{ .path = \"{imp}\" }},}});")
    # モジュール間依存関係の登録
    for importer, imports in deps_for_buildzig.items():
        importer_name = path_to_mod_name(importer)
        if importer not in already_declared:
            already_declared.append(importer)
            print(f"const {importer_name}_mod = b.addModule(\"{importer_name}\", .{{.root_source_file = .{{ .path = \"{importer}\" }},}});")
        for imp in imports:
            imp_name = path_to_mod_name(imp)
            print(f"{importer_name}_mod.addImport(\"{imp_name}\", {imp_name}_mod);")

if __name__ == "__main__":
    root_directory = "."  # ここで検索対象のフォルダを指定する（"."は現在のフォルダ）
    deps = collect_dependencies(root_directory)
    deps_for_buildzig = extract_deps_for_buildzig(deps)
    generate_description_for_buildzig(deps_for_buildzig)