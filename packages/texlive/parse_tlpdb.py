#!/usr/bin/python3
##
##  Script to parse texlive.tlpdb and get list of files in a package
##
##  Copyright (C) 2019 Henrik Grimler
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <https://www.gnu.org/licenses/>.

def parse_tlpdb_to_dict(tlpdb_path):
    """Reads given tlpdb database and creates dict with packages and their dependencies and files
    """

    with open(tlpdb_path, "r") as f:
        packages = f.read().split("\n\n")

    pkg_dict = {}
    for pkg in packages:
        if not pkg == "":
            pkg_lines = pkg.split("\n")
            pkg_name = pkg_lines[0].split(" ")[1]
            # We only care about getting all the files so only check for "depend" and files
            pkg_dict[pkg_name] = {"depends" : [], "files" : []}
            for line in pkg_lines:
                line_description = line.split(" ")[0]
                if line_description == "":
                    pkg_dict[pkg_name]["files"].append(line.split(" ")[1])
                elif line_description == "depend":
                    pkg_dict[pkg_name]["depends"].append(line.split(" ")[1])
    return pkg_dict

def get_files_in_package(package, files_in_package, visited_pkgs, visit_collections=False):
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
                    files_in_package, visited_pkgs = get_files_in_package(dep, files_in_package, visited_pkgs)
    return files_in_package, visited_pkgs

def Files(*args, **kwargs):
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
    for pkg in args[0]:
        files += get_files_in_package(prefix+pkg, [], [], visit_collections=bool_visit_collections)[0]
    return files

def get_conflicting_pkgs(package):
    """Returns list of packages that contain some files that are also found in 'package'.
    These packages should be listed as dependencies.
    """
    if package in ["basic", "fontsrecommended", "games", "luatex",
                   "music", "plaingeneric", "publishers", "texworks", "wintools"]:
        return []
    elif package in ["latex", "langeuropean", "langenglish", "langfrench",
                     "langgerman", "binextra", "fontutils", "langarabic",
                     "langgreek", "langitalian", "langother", "langpolish",
                     "langportuguese", "langspanish", "metapost"]:
        return ["basic"]
    elif package == "langczechslovak":
        return ["basic", "latex", "fontsextra", "luatex"]
    elif package == "langcyrillic":
        return ["basic", "latex", "fontsextra", "fontsrecommended",
                "langgreek", "latexrecommended"]
    elif package == "formatsextra":
        return ["basic", "latex", "langcyrillic", "mathscience",
                "fontsrecommended", "plaingeneric"]
    elif package == "context":
        return ["basic", "latex", "mathscience", "fontsrecommended",
                "metapost", "xetex"]
    elif package == "langjapanese":
        return ["basic", "latex", "langcjk", "langchinese"]
    elif package == "langchinese":
        return ["basic", "langcjk", "fontutils"]
    elif package == "bibtexextra":
        return ["basic", "binextra"]
    elif package == "langcjk":
        return ["basic", "langother"]
    elif package == "latexrecommended":
        return ["basic", "fontsrecommended", "latexextra", "pictures", "plaingeneric"]
    elif package == "mathscience":
        return ["basic", "langgreek"]
    elif package == "langkorean":
        return ["langjapanese", "langcjk", "latexrecommended"]
    elif package == "latexextra":
        return ["fontsextra"]
    elif package == "humanities":
        return ["latexextra"]
    elif package == "pictures":
        return ["latexextra"]
    elif package == "fontsextra":
        return ["plaingeneric"]
    elif package == "pstricks":
        return ["plaingeneric"]
    elif package == "xetex":
        return ["latex"]
    else:
        raise ValueError(sys.argv[1]+" isn't a known package name")


import sys
tlpdb = sys.argv[2]
pkg_dict = parse_tlpdb_to_dict(tlpdb)

if len(sys.argv) > 2 and sys.argv[-1] == "print_names":
    """Generate dependencies to put into TERMUX_SUBPKG_DEPENDS"""
    # Strip latex and basic since those collections are part of termux package "texlive"
    dependencies = ["texlive-"+pkg for pkg in get_conflicting_pkgs(sys.argv[1]) if not pkg in ["latex", "basic"]];
    if len(dependencies) > 0:
        print("texlive, "+", ".join(dependencies))
    else:
        print("texlive")
else:
    """Print files which should be included in the subpackage"""
    print("\n".join(["share/texlive/"+line for line in
                     list( set(Files([sys.argv[1]])) - set(Files(get_conflicting_pkgs(sys.argv[1]))) )]))
