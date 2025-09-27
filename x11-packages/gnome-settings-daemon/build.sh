TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-settings-daemon
TERMUX_PKG_DESCRIPTION="GNOME Settings Daemon"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.1-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.1"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-settings-daemon/${TERMUX_PKG_VERSION%%.*}/gnome-settings-daemon-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=3860a2ea214dcbcb6600ae7a1e3358a5389215087bc3e4a47cee3f87baee062e
TERMUX_PKG_DEPENDS="glib, geoclue, geocode-glib, gnome-desktop3, gtk3, libcanberra, libcolord, libgweather, libnotify, libx11, libxfixes, pango, polkit, pulseaudio-glib, upower"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=false
-Delogind=false
-Dalsa=false
-Dgudev=false
-Dwayland=false
-Dsmartcard=false
-Dcups=false
-Drfkill=false
-Dwwan=false
-Dnetwork_manager=false
"

termux_step_pre_configure() {
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

		# Use it in meson
		local _native_file="$TERMUX_PKG_TMPDIR"/native-file.ini
		echo "[binaries]" > $_native_file
		echo "pkg-config = '$TERMUX_PKG_TMPDIR/host-pkg-config/pkg-config'" >> $_native_file
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--native-file $_native_file $TERMUX_PKG_EXTRA_CONFIGURE_ARGS"
	fi

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
