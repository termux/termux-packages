TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-fontsextra"
TERMUX_SUBPKG_DEPENDS="texlive-plaingeneric"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py fontsextra $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410), texlive-latexextra (<= 20190410-2), texlive-fontutils (<= 20190410-2)"

termux_step_create_subpkg_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo mktexlsr >> postinst
}
