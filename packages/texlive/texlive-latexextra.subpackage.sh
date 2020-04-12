TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-latexextra"
TERMUX_SUBPKG_DEPENDS="texlive-fontsextra"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py latexextra $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<= 20190410-2), texlive-latexrecommended (<= 20190410-2), texlive-pictures (<= 20190410-2), texlive-luatex (<= 20190410-2), texlive-plaingeneric (<= 20190410-2)"

termux_step_create_subpkg_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo mktexlsr >> postinst
}
