TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/glib/
TERMUX_PKG_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
TERMUX_PKG_VERSION=2.54.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=bb89e5c5aad33169a8c7f28b45671c7899c12f74caf707737f784d7102758e6c
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib/${TERMUX_PKG_VERSION:0:4}/glib-${TERMUX_PKG_VERSION}.tar.xz
# libandroid-support to get langinfo.h in include path.
TERMUX_PKG_DEPENDS="libffi, pcre, libandroid-support"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc share/locale share/glib-2.0/gettext share/gdb/auto-load share/glib-2.0/codegen share/glib-2.0/gdb bin/gtester-report bin/glib-gettextize bin/gdbus-codegen"
# Needed by pkg-config for glib-2.0:
TERMUX_PKG_DEVPACKAGE_DEPENDS="pcre-dev"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="lib/glib-2.0/include"

# --enable-compile-warnings=no to get rid of format strings causing errors.
# --disable-znodelete to avoid DF_1_NODELETE which most Android 5.0 linkers does not support.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cache-file=termux_configure.cache
--disable-compile-warnings
--disable-gtk-doc
--disable-gtk-doc-html
--disable-libelf
--disable-libmount
--disable-znodelete
--with-pcre=system
"

termux_step_pre_configure () {
	# glib checks for __BIONIC__ instead of __ANDROID__:
	CFLAGS="$CFLAGS -D__BIONIC__=1"

	cd $TERMUX_PKG_BUILDDIR

	# https://developer.gnome.org/glib/stable/glib-cross-compiling.html
	echo "glib_cv_long_long_format=ll" >> termux_configure.cache
	echo "glib_cv_stack_grows=no" >> termux_configure.cache
	echo "glib_cv_uscore=no" >> termux_configure.cache
	chmod a-w termux_configure.cache
}
