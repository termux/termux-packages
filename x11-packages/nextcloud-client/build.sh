TERMUX_PKG_HOMEPAGE=https://nextcloud.com/
TERMUX_PKG_DESCRIPTION="Nextcloud desktop client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="34.0.5"
TERMUX_PKG_SRCURL="https://github.com/nextcloud/desktop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=cd520a7b5299c3ee6a5226e662530c38f064427fadab7c8f439e9595ff66f58f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^v\d+\.\d+\.\d+$'
TERMUX_PKG_DEPENDS="dbus, dbus-glib, libc++, libp11, openssl, qtkeychain, qt6-qtbase, inotify-tools, libsqlite, kdsingleapplication, kf6-karchive, kf6-kdbusaddons, kf6-kguiaddons, qt6-qtwebsockets, qt6-qtsvg, qt6-qt5compat"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools, pkg-config, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHELL_INTEGRATION=OFF
-DBUILD_UPDATER=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DTOKEN_AUTH_ONLY=OFF
-DBUILD_TESTING=OFF
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_download_ubuntu_packages librsvg2-bin librsvg2-2
		export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
		export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
		export PATH="${HOSTBUILD_ROOTFS}/usr/bin:$PATH"
	fi
}
