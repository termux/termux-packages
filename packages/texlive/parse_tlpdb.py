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
    """Reads given tlpdb database and creates dict with packages, their dependencies and files
    """

    with open(tlpdb_path, "r") as f:
        packages = f.read().split("\n\n")

    pkg_dict = {}
    for pkg in packages:
        if not pkg == "":
            pkg_lines = pkg.split("\n")
            pkg_name = pkg_lines[0].split(" ")[1]
            # We only care about files and depends
            pkg_dict[pkg_name] = {"depends" : [], "files" : []}
            i = 0
            while i < len(pkg_lines):
                if pkg_lines[i].split(" ")[0].startswith("runfiles"):
                    # Start of file list
                    i += 1
                    while i < len(pkg_lines) and pkg_lines[i].startswith(" "):
                        # files starts with space, for example
                        # " texmf-dist/tex/latex/collref/collref.sty"
                        pkg_dict[pkg_name]["files"].append(pkg_lines[i].split(" ")[1])
                        i += 1

                if i == len(pkg_lines):
                    break

                if pkg_lines[i].split(" ")[0] == "depend":
                    pkg_dict[pkg_name]["depends"].append(pkg_lines[i].split(" ")[1])

                i += 1

    return pkg_dict

def get_files_in_package(package, files_in_package, visited_pkgs, visit_collections=False):
    """Prints files in package and then run itself on each dependency. Doesn't visit collections unless argument visit_collections=True is passed.
    """
    for f in pkg_dict[package]["files"]:
        files_in_package.append(f)
    for dep in pkg_dict[package]["depends"]:
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

def Files(packages, bool_visit_collections = False):
    """
    Wrapper around function get_files. Does not visit collections unless bool_.
    """
    files = []
    for pkg in packages:
        files += get_files_in_package(pkg, [], [],
                                      visit_collections=bool_visit_collections)[0]
    return files

def get_conflicting_pkgs(package):
    """Returns list of packages that contain some files that are also found in 'package'.
    These packages should be listed as dependencies.
    """
    if package in ["collection-basic"]:
        conflicting_pkgs = []

    elif package in ["collection-latex"]:
        conflicting_pkgs = ["collection-basic"]

    elif package in ["collection-langeuropean",
                     "collection-langenglish",
                     "collection-langfrench",
                     "collection-langgerman",
                     "collection-binextra",
                     "collection-fontutils",
                     "collection-langarabic",
                     "collection-langgreek",
                     "collection-langitalian",
                     "collection-langother",
                     "collection-langpolish",
                     "collection-langportuguese",
                     "collection-langspanish",
                     "collection-metapost",
                     "collection-fontsrecommended",
                     "collection-games",
                     "collection-luatex",
                     "collection-music",
                     "collection-plaingeneric",
                     "collection-publishers",
                     "collection-texworks",
                     "collection-wintools"]:
        conflicting_pkgs = ["collection-basic",
                            "collection-latex"]

    elif package == "collection-langczechslovak":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-fontsextra",
                            "collection-luatex"]

    elif package == "collection-langcyrillic":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-fontsextra",
                            "collection-fontsrecommended",
                            "collection-langgreek",
                            "collection-latexrecommended"]

    elif package == "collection-formatsextra":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-langcyrillic",
                            "collection-mathscience",
                            "collection-fontsrecommended",
                            "collection-plaingeneric"]

    elif package == "collection-context":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-mathscience",
                            "collection-fontsrecommended",
                            "collection-metapost",
                            "collection-xetex"]

    elif package == "collection-langjapanese":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-langcjk",
                            "collection-langchinese"]

    elif package == "collection-langchinese":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-langcjk",
                            "collection-fontutils"]

    elif package == "collection-bibtexextra":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-binextra"]

    elif package == "collection-langcjk":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-langother"]

    elif package == "collection-latexrecommended":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-fontsrecommended",
                            "collection-latexextra",
                            "collection-pictures",
                            "collection-plaingeneric"]

    elif package == "collection-mathscience":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-langgreek"]

    elif package == "collection-langkorean":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-langjapanese",
                            "collection-langcjk",
                            "collection-latexrecommended"]

    elif package == "collection-latexextra":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-fontsextra"]

    elif package == "collection-humanities":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-latexextra"]

    elif package == "collection-pictures":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-latexextra"]

    elif package == "collection-fontsextra":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-plaingeneric",
                            "noto",
                            "alegreya",
                            "montserrat",
                            "fira",
                            "lato",
                            "mpfonts",
                            "libertine",
                            "drm",
                            "poltawski",
                            "cm-unicode",
                            "roboto",
                            "dejavu",
                            "plex",
                            "stickstoo",
                            "ebgaramond",
                            "ipaex-type1",
                            "paratype",
                            "antt",
                            "cormorantgaramond",
                            "libertinus-type1"]

    elif package == "collection-pstricks":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex",
                            "collection-plaingeneric"]

    elif package == "collection-xetex":
        conflicting_pkgs = ["collection-basic",
                            "collection-latex"]

    elif not package.startswith("collection-"):
        conflicting_pkgs = ["collection-basic",
                            "collection-latex"]
    else:
        raise ValueError(sys.argv[1]+" isn't a known package name")

    return conflicting_pkgs

if __name__ == '__main__':
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
                               set(Files(["dehyph-exptl",
                                          "hyphen-afrikaans",
                                          "kpathsea",
                                          "amsfonts",
                                          "texlive-scripts-extra",
                                          "l3backend",
                                          "latexconfig",
                                          "tex-ini-files"])) )]))
