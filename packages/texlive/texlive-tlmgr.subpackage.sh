TERMUX_SUBPKG_DESCRIPTION="Texlive's package manager"
TERMUX_SUBPKG_DEPENDS="wget, xz-utils, gnupg2, sed"
TERMUX_SUBPKG_CONFFILES="share/texlive/tlpkg/texlive.tlpdb"
TERMUX_SUBPKG_CONFLICTS="texlive (<< 20180414)"
TERMUX_SUBPKG_INCLUDE="
share/texlive/texmf-dist/scripts/texlive/tlmgr.pl
share/texlive/texmf-dist/scripts/texlive/tlmgrgui.pl
share/texlive/tlpkg
bin/tlmgr.ln
bin/tlmgr"
