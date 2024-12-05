TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Tools to configure LXQt and the underlying operating system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-config/releases/download/${TERMUX_PKG_VERSION}/lxqt-config-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fa81bdf793d396da8cc9aed1f61df532606152092ad0d3b52674e06b0121780d
TERMUX_PKG_DEPENDS="libc++, liblxqt, libqtxdg, libxcb, libxcursor, libxfixes, lxqt-menu-data, qt6-qtbase, shared-mime-info, zlib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
# libinput is required to switch on input configuration
# libkscreen is required to switch on monitor configuration, which in turn requires wayland
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_INPUT=OFF
-DWITH_MONITOR=OFF
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"

TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# This is required because of the private lib used by lxqt-config-appearance
	LDFLAGS+=" -Wl,-rpath=${TERMUX_PREFIX}/lib/lxqt-config"
	export LDFLAGS
}
