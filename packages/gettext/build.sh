TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gettext/
TERMUX_PKG_DESCRIPTION="GNU Internationalization utilities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.20.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gettext/gettext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=53f02fbbec9e798b0faaf7c73272f83608e835c6288dd58be6c9bb54624a3800
TERMUX_PKG_DEPENDS="libc++, libiconv, pcre, liblzma, libxml2, libcroco, ncurses, libunistring, zlib"
TERMUX_PKG_BREAKS="gettext-dev"
TERMUX_PKG_REPLACES="gettext-dev"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	autoreconf
}
