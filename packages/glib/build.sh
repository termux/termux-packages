TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/glib/
TERMUX_PKG_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
_TERMUX_GLIB_MAJOR_VERSION=2.48
TERMUX_PKG_VERSION=${_TERMUX_GLIB_MAJOR_VERSION}.2
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/gnome/sources/glib/${_TERMUX_GLIB_MAJOR_VERSION}/glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libffi, pcre"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc share/locale share/glib-2.0/gettext share/gdb/auto-load share/glib-2.0/codegen share/glib-2.0/gdb bin/gtester-report bin/glib-mkenums bin/glib-gettextize bin/gdbus-codegen"
# Needed by pkg-config for glib-2.0:
TERMUX_PKG_DEVPACKAGE_DEPENDS="pcre-dev"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="lib/glib-2.0/include"

# --enable-compile-warnings=no to get rid of format strings causing errors
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-compile-warnings --disable-gtk-doc --disable-gtk-doc-html --cache-file=termux_configure.cache --with-pcre=system"
# --disable-znodelete to avoid DF_1_NODELETE which most Android 5.0 linkers does not support:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-znodelete"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-libelf"

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
