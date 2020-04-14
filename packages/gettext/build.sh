TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gettext/
TERMUX_PKG_DESCRIPTION="GNU Internationalization utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.20.2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gettext/gettext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b22b818e644c37f6e3d1643a1943c32c3a9bff726d601e53047d2682019ceaba
TERMUX_PKG_DEPENDS="libc++, libiconv, pcre, liblzma, libxml2, libcroco, ncurses, libunistring, zlib"
TERMUX_PKG_BREAKS="gettext-dev"
TERMUX_PKG_REPLACES="gettext-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf
}
