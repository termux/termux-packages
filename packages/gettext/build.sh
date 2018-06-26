TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gettext/
TERMUX_PKG_DESCRIPTION="GNU Internationalization utilities"
TERMUX_PKG_VERSION=0.19.8
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gettext/gettext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9c1781328238caa1685d7bc7a2e1dcf1c6c134e86b42ed554066734b621bd12f
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="pcre, liblzma, libxml2, libcroco, ncurses, libunistring"
termux_step_pre_configure () {
	autoreconf
}
