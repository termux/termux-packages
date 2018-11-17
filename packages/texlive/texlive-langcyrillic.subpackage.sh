TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-langcyrillic"
TERMUX_SUBPKG_DEPENDS="texlive, texlive-fontsextra, texlive-fontsrecommended, texlive-langgreek, texlive-latexrecommended"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_PKG_BUILDER_DIR/parse_tlpdb.py $(echo $SUB_PKG_NAME | awk -F"-" '{print $2}') $TERMUX_PKG_TMPDIR/texlive.tlpdb)
