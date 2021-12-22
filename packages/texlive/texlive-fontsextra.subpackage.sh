TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-fontsextra"
# noto, alegreya, montserrat and so on are splitted out because they together
# consists of roughly 55 % of the total size of texlive-fontsextra
TERMUX_SUBPKG_DEPENDS="texlive-plaingeneric, texlive-noto, texlive-alegreya, texlive-montserrat, texlive-fira, texlive-lato, texlive-mpfonts, texlive-libertine, texlive-drm, texlive-poltawski, texlive-cm-unicode, texlive-roboto, texlive-dejavu, texlive-plex, texlive-stickstoo, texlive-ebgaramond, texlive-ipaex-type1, texlive-paratype, texlive-antt, texlive-cormorantgaramond, texlive-libertinus-type1"
TERMUX_SUBPKG_INCLUDE=$($TERMUX_PKG_BUILDER_DIR/parse_tlpdb.py collection-fontsextra $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410), texlive-latexextra (<= 20190410-2), texlive-fontutils (<= 20190410-2)"

termux_step_create_subpkg_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo 'PATH=$PATH:$PREFIX/bin/texlive mktexlsr' >> postinst
}
