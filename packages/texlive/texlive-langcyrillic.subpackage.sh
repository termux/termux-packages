TERMUX_SUBPKG_DESCRIPTION="Texlive's collection-langcyrillic"
TERMUX_SUBPKG_DEPENDS="texlive-fontsextra, texlive-fontsrecommended, texlive-langgreek, texlive-latexrecommended"
TERMUX_SUBPKG_INCLUDE=$(python3 $TERMUX_SCRIPTDIR/packages/texlive/parse_tlpdb.py langcyrillic $TERMUX_PKG_TMPDIR/texlive.tlpdb)
TERMUX_SUBPKG_CONFLICTS="texlive-bin (<< 20190410), texlive (<< 20190410)"
