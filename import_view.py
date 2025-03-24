import os
import re

def path_to_mod_name(path):
    # '../' などを正規化して除去する
    normalized = re.sub(r'^(\.\./)+', '', os.path.normpath(path))
    # 拡張子を除去する
    no_extension = os.path.splitext(normalized)[0]
    # '/'を'_'に置き換える
    slash_replace = no_extension.replace('/', '_')
    return slash_replace

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
            if filename.endswith(".zig"):
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
def dataset_for_buildzig(dependencies):
    build_dir = os.path.join(root_directory, "OBJ_ARM")
    mod_paths = {}
    dep_mods = {}
    for file, imports in dependencies.items():
        mod_path = os.path.relpath(file, build_dir)
        mod_name = path_to_mod_name(mod_path)
        if mod_name is not mod_paths.keys():
            mod_paths[mod_name] = mod_path
        dep_mods[mod_name] = [path_to_mod_name(imp) for imp in imports]
    return (mod_paths, dep_mods)

# build.zigへの記述を自動生成
def generate_description_for_buildzig(build_datasets):
    pass

if __name__ == "__main__":
    root_directory = "."  # ここで検索対象のフォルダを指定する（"."は現在のフォルダ）
    deps = collect_dependencies(root_directory)
    mods = dataset_for_buildzig(deps)
    print(mods)