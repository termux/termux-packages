TERMUX_PKG_HOMEPAGE=https://github.com/mypaint/libmypaint
TERMUX_PKG_DESCRIPTION="MyPaint brush engine library"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/mypaint/libmypaint/releases/download/v${TERMUX_PKG_VERSION}/libmypaint-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=741754f293f6b7668f941506da07cd7725629a793108bb31633fb6c3eae5315f
TERMUX_PKG_DEPENDS="glib, json-c"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-introspection
--with-glib
ac_cv_func_bind_textdomain_codeset=yes
ac_cv_search_dgettext=yes
gt_cv_func_dgettext_libc=yes
gt_cv_func_ngettext_libc=yes
"
