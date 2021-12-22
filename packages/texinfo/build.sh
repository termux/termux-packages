TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/texinfo/
TERMUX_PKG_DESCRIPTION="Documentation system for on-line information and printed output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.8
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/texinfo/texinfo-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8eb753ed28bca21f8f56c1a180362aed789229bd62fff58bf8368e9beb59fec4
# gawk is used by texindex:
TERMUX_PKG_DEPENDS="libiconv, ncurses, perl, gawk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-perl-xs"
TERMUX_PKG_GROUPS="base-devel"
