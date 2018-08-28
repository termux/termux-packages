#!/data/data/com.termux/files/usr/bin/python3

def parse_tlpdb_to_dict(tlpdb_path):
    """Reads given tlpdb database and creates dict with packages and their dependencies and files
    """

    with open(tlpdb, "r") as f:
        packages = f.read().split("\n\n")

    pkg_dict = {}
    for pkg in packages:
        if not pkg == "":
            pkg_lines = pkg.split("\n")
            pkg_name = pkg_lines[0].split(" ")[1]
            # We only care about getting all the files so only check for "depend" and files
            pkg_dict[pkg_name] = {"depends" : [], "files" : []}
            for line in pkg_lines:
                line_descr = line.split(" ")[0]
                if line_descr == "":
                    pkg_dict[pkg_name]["files"].append(line.split(" ")[1])
                elif line_descr == "depend":
                    pkg_dict[pkg_name]["depends"].append(line.split(" ")[1])
    return pkg_dict
                    
def get_files(package, files_in_package, visited_pkgs, visit_collections=False):
    """Prints files in package and then run itself on each dependency. Doesn't visit collections unless argument visit_collections=True is passed.
    """
    for f in pkg_dict[package]["files"]:
        files_in_package.append(f)
    for dep in pkg_dict[package]["depends"]:
        # skip arch dependent packages, which we lack since we build our own binaries:
        if not dep.split(".")[-1] == "ARCH":
            # skip collections unless explicitly told to go through them
            if not dep.split("-")[0] == "collection" or visit_collections:
                # avoid duplicates:
                if not dep in visited_pkgs:
                    visited_pkgs.append(dep)
                    files_in_package, visited_pkgs = get_files(dep, files_in_package, visited_pkgs)
    return files_in_package, visited_pkgs

def files(*args, **kwargs):
    """Wrapper around function get_files. Prepends "collection-" to package unless prepend_collection=False is passed. Also uses visit_collections=False per default.
    """
    prefix = "collection-"
    bool_visit_collections = False
    for k,v in kwargs.items():
        if k == "prepend_collection" and not v:
            prefix = ""
        elif k == "visit_collections" and v:
            bool_visit_collections = True

    files = []
    for pkg in args:
        files += get_files(prefix+pkg, [], [], visit_collections=bool_visit_collections)[0]
    return files

import sys
tlpdb = sys.argv[2]
pkg_dict = parse_tlpdb_to_dict(tlpdb)


if sys.argv[1] in ["basic", "fontsrecommended", "games", "luatex", "music", "plaingeneric", "publishers", "texworks", "wintools"]:
    files = set(files(sys.argv[1]))
elif sys.argv[1] in ["latex", "langeuropean", "langenglish", "langfrench", "langgerman", "binextra", "fontutils", "langarabic", "langgreek", "langitalian", "langother", "langpolish", "langportuguese", "langspanish", "metapost"]:
    files = set(files(sys.argv[1])) - set(files("basic"))
elif sys.argv[1] == "langczechslovak":
    files = set(files(sys.argv[1])) - set(files("basic", "latex", "fontsextra", "luatex"))
elif sys.argv[1] == "langcyrillic":
    files = set(files(sys.argv[1])) - set(files("basic", "latex", "fontsextra", "fontsrecommended", "langgreek", "latexrecommended"))
elif sys.argv[1] == "formatsextra":
    files = set(files(sys.argv[1])) - set(files("basic", "latex", "langcyrillic", "mathscience", "fontsrecommended", "plaingeneric"))
elif sys.argv[1] == "context":
    files = set(files(sys.argv[1])) - set(files("basic", "latex", "mathscience", "fontsrecommended", "metapost", "xetex"))
elif sys.argv[1] == "langjapanese":
    files = set(files(sys.argv[1])) - set(files("basic", "latex", "langcjk", "langchinese"))
elif sys.argv[1] == "langchinese":
    files = set(files(sys.argv[1])) - set(files("basic", "langcjk", "fontutils"))
elif sys.argv[1] == "bibtexextra":
    files = set(files(sys.argv[1])) - set(files("basic", "binextra"))
elif sys.argv[1] == "langcjk":
    files = set(files(sys.argv[1])) - set(files("basic", "langkorean", "langother"))
elif sys.argv[1] == "latexrecommended":
    files = set(files(sys.argv[1])) - set(files("basic", "fontsrecommended", "latexextra", "pictures", "plaingeneric"))
elif sys.argv[1] == "mathscience":
    files = set(files(sys.argv[1])) - set(files("basic", "langgreek"))
elif sys.argv[1] == "langkorean":
    files = set(files(sys.argv[1])) - set(files("langjapanese", "latexrecommended"))
elif sys.argv[1] == "latexextra":
    files = set(files(sys.argv[1])) - set(files("fontsextra"))
elif sys.argv[1] == "humanities":
    files = set(files(sys.argv[1])) - set(files("latexextra"))
elif sys.argv[1] == "pictures":
    files = set(files(sys.argv[1])) - set(files("latexextra"))
elif sys.argv[1] == "fontsextra":
    files = set(files(sys.argv[1])) - set(files("plaingeneric"))
elif sys.argv[1] == "pstricks":
    files = set(files(sys.argv[1])) - set(files("plaingeneric"))
elif sys.argv[1] == "xetex":
    files = set(files(sys.argv[1])) - set(files("latex"))
else:
    raise ValueError(sys.argv[1]+" isn't a known package name")

print("\n".join(["share/texlive/"+line for line in list(files)]))
