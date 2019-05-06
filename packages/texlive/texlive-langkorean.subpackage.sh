TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-langkorean"
TERMUX_SUBPKG_DEPENDS="texlive-langjapanese, texlive-langcjk, texlive-latexrecommended"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py langkorean $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410)"
