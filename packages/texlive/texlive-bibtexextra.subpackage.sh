TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-bibtexextra"
TERMUX_SUBPKG_DEPENDS="texlive-binextra"
TERMUX_SUBPKG_INCLUDE=$($TERMUX_PKG_BUILDER_DIR/parse_tlpdb.py collection-bibtexextra $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<= 20190410-2)"

termux_step_create_subpkg_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo 'PATH=$PATH:$PREFIX/bin/texlive mktexlsr' >> postinst
}
