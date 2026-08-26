TERMUX_PKG_HOMEPAGE=https://nextcloud.com/
TERMUX_PKG_DESCRIPTION="Nextcloud desktop client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="34.0.3"
TERMUX_PKG_SRCURL="https://github.com/nextcloud/desktop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d0994a9a9d7864d216e51af71d83a7f28382d255470317829ab538cee5aaffcd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="dbus, dbus-glib, libc++, libp11, openssl, qtkeychain, qt6-qtbase, inotify-tools, libsqlite, kdsingleapplication, kf6-karchive, kf6-kdbusaddons, kf6-kguiaddons, qt6-qtwebsockets, qt6-qtsvg, qt6-qt5compat"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools, pkg-config, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHELL_INTEGRATION=OFF
-DBUILD_UPDATER=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DTOKEN_AUTH_ONLY=OFF
-DBUILD_TESTING=OFF
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_download_ubuntu_packages librsvg2-bin librsvg2-2
	fi
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper_bin"
		mkdir -p "${_WRAPPER_BIN}"
		cat <<-EOF >"${_WRAPPER_BIN}/rsvg-convert"
			#!/bin/sh
			export LD_LIBRARY_PATH="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/lib/x86_64-linux-gnu"
			exec "${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/bin/rsvg-convert" "\$@"
		EOF
		chmod +x "${_WRAPPER_BIN}/rsvg-convert"
		export PATH="${_WRAPPER_BIN}:${PATH}"
	fi
}
