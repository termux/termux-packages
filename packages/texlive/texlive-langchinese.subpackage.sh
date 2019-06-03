TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-langchinese"
TERMUX_SUBPKG_DEPENDS="texlive-langcjk, texlive-fontutils"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py langchinese $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410)"
