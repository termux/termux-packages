TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/rhythmbox
TERMUX_PKG_DESCRIPTION="Music playback and management application"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.7"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/rhythmbox/${TERMUX_PKG_VERSION%.*}/rhythmbox-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2f6d56c13fc1a64c534f500788fb482936ce547b343ed90c67de1f2bce0cfa7e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="at-spi2-core, gdk-pixbuf, glib, gobject-introspection, gst-plugins-base, gstreamer, gtk3, json-glib, libcairo, libnotify, libpeas, libsoup3, libtdb, libx11, libxml2, pango, pygobject, python, totem-pl-parser"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RECOMMENDS="rhythmbox-help"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
-Dhelp=true
-Dplugins_python=enabled
-Dplugins_vala=enabled
-Dtests=disabled
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir

	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"
}
