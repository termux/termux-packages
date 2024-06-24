TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/rncbc/qpwgraph
TERMUX_PKG_DESCRIPTION="PipeWire Graph Qt GUI Interface"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.7.2
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/rncbc/qpwgraph/-/archive/v$TERMUX_PKG_VERSION/qpwgraph-v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=166f5f6cd87c082b65092fb9d3aa7ab16938acc78c610b36a16adc61ac8295a0
TERMUX_PKG_DEPENDS="hicolor-icon-theme, qt6-qtbase, qt6-qtsvg, pipewire"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCONFIG_SYSTEM_TRAY=no"
