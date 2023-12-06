TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/FileRoller
TERMUX_PKG_DESCRIPTION="File Roller is an archive manager for the GNOME desktop environment."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="43.1"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/file-roller/${TERMUX_PKG_VERSION%.*}/file-roller-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=84994023997293beb345d9793db8f5f0bbb41faa155c6ffb48328f203957ad08
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, json-glib, libarchive, libcairo, libhandy, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RECOMMENDS="arj, brotli, bsdtar, bzip2, cpio, gzip, lz4, lzip, lzop, p7zip, tar, unrar, unzip, xz-utils, zip, zstd"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Duse_native_appchooser=false
-Dcpio=$TERMUX_PREFIX/bin/cpio
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir

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
