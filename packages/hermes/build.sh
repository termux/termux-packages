TERMUX_PKG_HOMEPAGE=https://hermesengine.dev
TERMUX_PKG_DESCRIPTION="A Javascript Engine optimized for running react native"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_BUILD_DEPENDS="libicu, readline"
TERMUX_PKG_SRCURL=https://github.com/facebook/hermes/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=bd8fd158381813483123eb1ab553ed08db68e4949f314c99ee8fa79fa8f3e7ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
    cd "$TERMUX_PKG_SRCDIR"
    cmake -B ./build_host_hermesc && cmake --build ./build_host_hermesc --target hermesc
    TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DIMPORT_HERMESC:PATH=$TERMUX_PKG_SRCDIR/ImportHermesc.cmake"
}
