TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-settings-daemon
TERMUX_PKG_DESCRIPTION="GNOME Settings Daemon"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.1-only"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="49.1"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-settings-daemon/${TERMUX_PKG_VERSION%%.*}/gnome-settings-daemon-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=2a9957fc4f91c3b9127b49484179bef485120d9c1c208e44d44e6a746e6cc1c1
TERMUX_PKG_DEPENDS="alsa-lib, cups, fontconfig, glib, geoclue, geocode-glib, gnome-desktop4, gtk3, libcanberra, libcolord, libgweather, libnotify, libx11, libxfixes, pango, pulseaudio-glib, upower"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd=false
-Delogind=false
-Dalsa=true
-Dgudev=false
-Dsmartcard=false
-Dcups=true
-Drfkill=false
-Dwwan=false
-Dnetwork_manager=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	mkdir -p "$TERMUX_PKG_TMPDIR"/host-pkg-config
	cat > "$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config <<-HERE
		#!/bin/sh
		unset PKG_CONFIG_DIR
		unset PKG_CONFIG_LIBDIR
		exec /usr/bin/pkg-config "\$@"
	HERE
	chmod +x "$TERMUX_PKG_TMPDIR"/host-pkg-config/pkg-config
	export PATH="$TERMUX_PKG_TMPDIR/host-pkg-config:$PATH"

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
