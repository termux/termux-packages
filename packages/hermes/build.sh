TERMUX_PKG_HOMEPAGE=https://hermesengine.dev
TERMUX_PKG_DESCRIPTION="A Javascript Engine optimized for running react native"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_QUIET_BUILD="true"
TERMUX_INSTALL_DEPS="true"
TERMUX_PKG_DEPENDS="libicu, readline"
TERMUX_PKG_SRCURL=https://github.com/facebook/hermes/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=bd8fd158381813483123eb1ab553ed08db68e4949f314c99ee8fa79fa8f3e7ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DIMPORT_HERMESC:PATH=$TERMUX_PKG_SRCDIR/../build/ImportHermesc.cmake"

termux_step_pre_configure(
    autoreconf -fi
)
