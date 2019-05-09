TERMUX_SUBPKG_INCLUDE="
bin/*
share/man/*
share/vim/vimrc
"

TERMUX_SUBPKG_DESCRIPTION="Vi IMproved - enhanced vi editor"
TERMUX_SUBPKG_DEPENDS="diffutils, libiconv, ncurses"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=yes
TERMUX_SUBPKG_CONFFILES="share/vim/vimrc"
TERMUX_SUBPKG_CONFLICTS="vim-python"
