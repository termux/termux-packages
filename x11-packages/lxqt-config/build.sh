TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Tools to configure LXQt and the underlying operating system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-config/releases/download/${TERMUX_PKG_VERSION}/lxqt-config-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=23c1c9a3aa3bf3537b3433439501463ea3e29950ecf2381679bf30ef4c1b245b
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

