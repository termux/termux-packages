TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-langczechslovak"
TERMUX_SUBPKG_DEPENDS="texlive, texlive-fontsextra, texlive-luatex"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py langczechslovak $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410)"
