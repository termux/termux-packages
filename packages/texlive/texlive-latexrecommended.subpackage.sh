TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-latexrecommended"
TERMUX_SUBPKG_DEPENDS="texlive-fontsrecommended, texlive-latexextra, texlive-pictures, texlive-plaingeneric"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py latexrecommended $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410)"
