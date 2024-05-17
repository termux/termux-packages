TERMUX_PKG_HOMEPAGE=https://gedit-technology.github.io/apps/gedit/
TERMUX_PKG_DESCRIPTION="GNOME Text Editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="47.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gedit/${TERMUX_PKG_VERSION%.*}/gedit-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fa4a597e34c76d4ac91431b5ae6e191c96c6b0af1702e0899ab35199edfa1bfa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gobject-introspection, gsettings-desktop-schemas, gspell, gtk3, libcairo, libgedit-amtk, libgedit-gfls, libgedit-gtksourceview, libgedit-tepl, libpeas, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RECOMMENDS="gedit-help"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
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
