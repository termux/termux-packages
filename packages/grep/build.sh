TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/grep/
TERMUX_PKG_DESCRIPTION="Command which searches one or more input files for lines containing a match to a specified pattern"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION=3.12
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/grep/grep-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2649b27c0e90e632eadcd757be06c6e9a4f48d941de51e7c0f83ff76408a07b9
TERMUX_PKG_DEPENDS="libandroid-support, pcre2"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_GROUPS="base-devel"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_nl_langinfo=no
ac_cv_header_langinfo_h=no
am_cv_langinfo_codeset=no
gl_cv_func_setlocale_works=yes
"
# Avoid automagic dependency on libiconv
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" am_cv_func_iconv=no"
