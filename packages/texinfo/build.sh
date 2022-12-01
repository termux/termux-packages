TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/texinfo/
TERMUX_PKG_DESCRIPTION="Documentation system for on-line information and printed output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/texinfo/texinfo-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bcd221fdb2d807a8a09938a0f8d5e010ebd2b58fca16075483d6fcb78db2c6b2
# gawk is used by texindex:
TERMUX_PKG_DEPENDS="libiconv, ncurses, perl, gawk"
TERMUX_PKG_RECOMMENDS="update-info-dir"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-perl-xs"
TERMUX_PKG_GROUPS="base-devel"
