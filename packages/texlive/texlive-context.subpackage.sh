TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-context"
TERMUX_SUBPKG_DEPENDS="texlive, texlive-mathscience, texlive-fontsrecommended, texlive-metapost, texlive-xetex"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py context $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410)"
