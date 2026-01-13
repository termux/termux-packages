TERMUX_PKG_HOMEPAGE=https://github.com/ibus/ibus
TERMUX_PKG_DESCRIPTION="Intelligent Input Bus for Linux/Unix"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.33"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://github.com/ibus/ibus/releases/download/$TERMUX_PKG_VERSION/ibus-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=58941c9b8285891c776b67fb2039eebe0d61d63a51578519febfc5481b91e831
TERMUX_PKG_DEPENDS="dconf, glib, gobject-introspection, gtk3, gtk4, ibus-data, libdbusmenu, libnotify, libwayland, libx11, libxfixes, libxi, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, libdbusmenu-static, unicode-cldr, unicode-data, unicode-emoji"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_SETUP_PYTHON=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--enable-introspection
--disable-vala
--disable-gtk2
--enable-dconf
--enable-gtk4
--disable-memconf
--enable-ui
--disable-python2
--disable-python-library
--disable-systemd-services
--with-emoji-annotation-dir=$TERMUX_PREFIX/share/unicode-cldr/annotations
--with-unicode-emoji-dir=$TERMUX_PREFIX/share/unicode-emoji
--with-ucd-dir=$TERMUX_PREFIX/share/unicode-data
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		# Create host pkg-config wrapper
		mkdir -p "$TERMUX_PKG_TMPDIR"/host-pkg-config
		cat > "$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config <<-EOF
			#!/bin/sh
			unset PKG_CONFIG_DIR
			unset PKG_CONFIG_LIBDIR
			exec /usr/bin/pkg-config "\$@"
		EOF
		chmod +x "$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config
		export PKG_CONFIG_FOR_BUILD="$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config

		DESTINATION="$TERMUX_PKG_TMPDIR/prefix" \
		termux_download_ubuntu_packages dconf-cli

		export PATH="$TERMUX_PKG_TMPDIR/prefix/usr/bin:$PATH"
	fi
}
