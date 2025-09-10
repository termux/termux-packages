TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/m4/m4.html
TERMUX_PKG_DESCRIPTION="Traditional Unix macro processor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.19
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/m4/m4-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_GROUPS="base-devel"
TERMUX_PKG_EXTRA_MAKE_ARGS="
HELP2MAN=:
"
# Avoid automagic dependency on libiconv
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" am_cv_func_iconv=no"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
}
