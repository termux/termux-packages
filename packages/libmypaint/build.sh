TERMUX_PKG_HOMEPAGE=https://github.com/mypaint/libmypaint
TERMUX_PKG_DESCRIPTION="MyPaint brush engine library"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/mypaint/libmypaint/releases/download/v${TERMUX_PKG_VERSION}/libmypaint-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=741754f293f6b7668f941506da07cd7725629a793108bb31633fb6c3eae5315f
TERMUX_PKG_DEPENDS="glib, json-c"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection
--with-glib
ac_cv_func_bind_textdomain_codeset=yes
ac_cv_search_dgettext=yes
gt_cv_func_dgettext_libc=yes
gt_cv_func_ngettext_libc=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_post_configure() {
	# What is this?
	find . -name Makefile | xargs -n 1 sed -i 's/ yes -lm/ -lm/g'
}
