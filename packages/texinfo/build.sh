TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/texinfo/
TERMUX_PKG_DESCRIPTION="Documentation system for on-line information and printed output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.1"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/texinfo/texinfo-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=deeec9f19f159e046fdf8ad22231981806dac332cc372f1c763504ad82b30953
TERMUX_PKG_AUTO_UPDATE=true
# gawk is used by texindex:
TERMUX_PKG_DEPENDS="libiconv, ncurses, perl, gawk"
TERMUX_PKG_RECOMMENDS="update-info-dir"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="texinfo_cv_sys_iconv_converts_euc_cn=no --disable-perl-xs"
TERMUX_PKG_GROUPS="base-devel"
