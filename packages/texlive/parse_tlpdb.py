#!/usr/bin/python3
##
##  Script to parse texlive.tlpdb and get list of files in a package
##
##  Copyright (C) 2019-2020 Henrik Grimler
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
        print(dep.split("."))
        if dep.split(".")[-1] == "ARCH":
            # skip arch dependent packages, which we lack since we build our own binaries
            continue

        if dep.split("-")[0] == "collection" or visit_collections:
            # skip collections unless explicitly told to go through them
            continue

        if not dep in visited_pkgs:
            # avoid duplicates
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
    if package in ["basic"]:
        conflicting_pkgs = []
    elif package in ["latex"]:
        conflicting_pkgs = ["basic"]
    elif package in ["langeuropean", "langenglish", "langfrench", "langgerman",
                     "binextra", "fontutils", "langarabic", "langgreek",
                     "langitalian", "langother", "langpolish", "langportuguese",
                     "langspanish", "metapost", "fontsrecommended", "games",
                     "luatex", "music", "plaingeneric", "publishers",
                     "texworks", "wintools"]:
        conflicting_pkgs = ["basic", "latex"]
    elif package == "langczechslovak":
        conflicting_pkgs = ["basic", "latex", "fontsextra", "luatex"]
    elif package == "langcyrillic":
        conflicting_pkgs = ["basic", "latex", "fontsextra", "fontsrecommended",
                "langgreek", "latexrecommended"]
    elif package == "formatsextra":
        conflicting_pkgs = ["basic", "latex", "langcyrillic", "mathscience",
                "fontsrecommended", "plaingeneric"]
    elif package == "context":
        conflicting_pkgs = ["basic", "latex", "mathscience", "fontsrecommended",
                "metapost", "xetex"]
    elif package == "langjapanese":
        conflicting_pkgs = ["basic", "latex", "langcjk", "langchinese"]
    elif package == "langchinese":
        conflicting_pkgs = ["basic", "latex", "langcjk", "fontutils"]
    elif package == "bibtexextra":
        conflicting_pkgs = ["basic", "latex", "binextra"]
    elif package == "langcjk":
        conflicting_pkgs = ["basic", "latex", "langother"]
    elif package == "latexrecommended":
        conflicting_pkgs = ["basic", "latex", "fontsrecommended", "latexextra", "pictures", "plaingeneric"]
    elif package == "mathscience":
        conflicting_pkgs = ["basic", "latex", "langgreek"]
    elif package == "langkorean":
        conflicting_pkgs = ["basic", "latex", "langjapanese", "langcjk", "latexrecommended"]
    elif package == "latexextra":
        conflicting_pkgs = ["basic", "latex", "fontsextra"]
    elif package == "humanities":
        conflicting_pkgs = ["basic", "latex", "latexextra"]
    elif package == "pictures":
        conflicting_pkgs = ["basic", "latex", "latexextra"]
    elif package == "fontsextra":
        conflicting_pkgs = ["basic", "latex", "plaingeneric"]
    elif package == "pstricks":
        conflicting_pkgs = ["basic", "latex", "plaingeneric"]
    elif package == "xetex":
        conflicting_pkgs = ["basic", "latex"]
    else:
        raise ValueError(sys.argv[1]+" isn't a known package name")

    return conflicting_pkgs

import sys
tlpdb = sys.argv[2]
pkg_dict = parse_tlpdb_to_dict(tlpdb)

if len(sys.argv) > 2 and sys.argv[-1] == "print_names":
    """Generate dependencies to put into TERMUX_SUBPKG_DEPENDS"""
    # Strip latex and basic since those are part of termux package "texlive"
    pkgs_in_texlive = ["latex", "basic"]
    dependencies = ["texlive-"+pkg for pkg in get_conflicting_pkgs(sys.argv[1]) if not pkg in pkgs_in_texlive]
    if len(dependencies) > 0:
        print("texlive, "+", ".join(dependencies))
    else:
        print("texlive")
else:
    """Print files which should be included in the subpackage"""
    # The last set of packages are needed to make our texlive package able to
    # generate pdflatex.fmt and compile a simple LaTeX test file, so they
    # should be part of texlive.
    print("\n".join(["share/texlive/"+line for line in
                     list( set(Files([sys.argv[1]])) -
                           set(Files(get_conflicting_pkgs(sys.argv[1]))) -
                           set(Files(["dehyph-exptl", "hyphen-afrikaans", "kpathsea", "amsfonts", "texlive-scripts-extra", "l3backend", "latexconfig", "tex-ini-files"], prepend_collection=False)) )]))
