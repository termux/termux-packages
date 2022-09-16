TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/sed/
TERMUX_PKG_DESCRIPTION="GNU stream editor for filtering/transforming text"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.8
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/sed/sed-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="base-devel"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_nl_langinfo=no
ac_cv_header_langinfo_h=no
am_cv_langinfo_codeset=no
gl_cv_func_setlocale_works=yes
"

termux_step_pre_configure() {
	CFLAGS+=" -D__USE_FORTIFY_LEVEL=2"
}

termux_step_post_configure() {
	touch -d "next hour" $TERMUX_PKG_SRCDIR/doc/sed.1
}
