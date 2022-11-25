TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/glib/
TERMUX_PKG_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.74
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib/${_MAJOR_VERSION}/glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ddf03e9bc7ea5717ef3c2f77c0714913a1726adc0bf3e8247cf41475284ec7bc
TERMUX_PKG_DEPENDS="libffi, libiconv, pcre2, libandroid-support, zlib"
TERMUX_PKG_BREAKS="glib-dev"
TERMUX_PKG_REPLACES="glib-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibmount=disabled
-Diconv=external
"

TERMUX_PKG_RM_AFTER_INSTALL="
lib/locale
share/gdb/auto-load
share/glib-2.0/gdb
share/glib-2.0/gettext
share/gtk-doc
bin/gtester-report
bin/glib-gettextize
"

termux_step_pre_configure() {
	# glib checks for __BIONIC__ instead of __ANDROID__:
	CFLAGS+=" -D__BIONIC__=1"
}

termux_step_create_debscripts() {
	for i in postinst postrm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
