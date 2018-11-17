TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-context"
TERMUX_SUBPKG_DEPENDS="texlive, texlive-mathscience, texlive-fontsrecommended, texlive-metapost, texlive-xetex"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_PKG_BUILDER_DIR/parse_tlpdb.py $(echo $SUB_PKG_NAME | awk -F"-" '{print $2}') $TERMUX_PKG_TMPDIR/texlive.tlpdb)
