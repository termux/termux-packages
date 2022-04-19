TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Tools to configure LXQt and the underlying operating system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-config/releases/download/${TERMUX_PKG_VERSION}/lxqt-config-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=64d7dd43e5ec1f98f0ba41e99f4438bb1f881fcbc2b2931f798cc82643c2d8a5
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, liblxqt, libxcb, zlib, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
# libinput is required to switch on input configuration
# libkscreen is required to switch on monitor configuration, which in turn requires wayland
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_INPUT=OFF -DWITH_MONITOR=OFF"

termux_step_pre_configure() {
    # This is required because of the private lib used by lxqt-config-appearance
    LDFLAGS+=" -Wl,-rpath=${TERMUX_PREFIX}/lib/lxqt-config"
    export LDFLAGS
}

