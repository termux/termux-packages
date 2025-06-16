TERMUX_PKG_HOMEPAGE=https://github.com/ibus/ibus
TERMUX_PKG_DESCRIPTION="Intelligent Input Bus for Linux/Unix"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.32"
TERMUX_PKG_SRCURL="https://github.com/ibus/ibus/releases/download/$TERMUX_PKG_VERSION/ibus-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b24f41ae38b236b254c09f1a8f53c2354b69b0789e89cea888d0494b09d15d67
TERMUX_PKG_DEPENDS="dconf, glib, gobject-introspection, gtk3, gtk4, libdbusmenu, libnotify, libwayland, libx11, libxfixes, libxi, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, libdbusmenu-static, unicode-cldr-common, unicode-data, unicode-emoji"
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--enable-introspection
--disable-vala
--disable-gtk2
--enable-gtk4
--disable-memconf
--enable-ui
--disable-python2
--disable-python-library
--disable-systemd-services
--with-emoji-annotation-dir=$TERMUX_PREFIX/share/unicode-cldr-common/annotations
--with-unicode-emoji-dir=$TERMUX_PREFIX/share/unicode-emoji
--with-ucd-dir=$TERMUX_PREFIX/share/unicode-data
"

termux_step_pre_configure() {
	TERMUX_PKG_DEPENDS+=", ibus-data"

	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		# Create host pkg-config wrapper
		mkdir -p "$TERMUX_PKG_TMPDIR"/host-pkg-config
		cat > "$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config <<-HERE
			#!/bin/sh
			unset PKG_CONFIG_DIR
			unset PKG_CONFIG_LIBDIR
			exec /usr/bin/pkg-config "\$@"
		HERE
		chmod +x "$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config
		export PKG_CONFIG_FOR_BUILD="$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config
	fi
}
