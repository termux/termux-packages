TERMUX_PKG_HOMEPAGE=https://bitbucket.org/tagoh/liblangtag/wiki/Home
TERMUX_PKG_DESCRIPTION="interface library to access/deal with tags for identifying languages"
TERMUX_PKG_LICENSE="LGPL-2.1, MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.7"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://bitbucket.org/tagoh/liblangtag/downloads/liblangtag-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=5ed6bcd4ae3f3c05c912e62f216cd1a44123846147f729a49fb5668da51e030e
TERMUX_PKG_DEPENDS="libxml2"
# --disable-introspection avoids LangTag-0.6: cannot execute binary file: Exec format error
# if gobject-introspection was installed in the same container before cross-compiling
# another workaround is probably to set gobject-introspection as a dependency,
# then generate and apply a gir-folder to the package,
# then use termux_setup_gir during termux_step_pre_configure, but currently the package was not written
# with gobject-introspection in mind, so consider it unnecessary until someone needs that in this package.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-introspection
"

termux_step_pre_configure() {
	export ac_cv_va_copy=C99
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}
