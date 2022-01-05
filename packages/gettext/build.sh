TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gettext/
TERMUX_PKG_DESCRIPTION="GNU Internationalization utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.21
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gettext/gettext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d20fcbb537e02dcf1383197ba05bd0734ef7bf5db06bdb241eb69b7d16b73192
TERMUX_PKG_DEPENDS="libc++, libiconv, pcre, liblzma, libxml2, libcroco, ncurses, libunistring, zlib"
TERMUX_PKG_BREAKS="gettext-dev"
TERMUX_PKG_REPLACES="gettext-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-openmp"
TERMUX_PKG_GROUPS="base-devel"

termux_step_pre_configure() {
	autoreconf
}
