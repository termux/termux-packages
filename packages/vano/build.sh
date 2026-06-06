TERMUX_PKG_HOMEPAGE=https://github.com/therealviren/vano
TERMUX_PKG_DESCRIPTION="Vano - C++ TUI text editor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.0.1

TERMUX_PKG_SRCURL=https://github.com/therealviren/vano/archive/refs/tags/v1.0.1.tar.gz
TERMUX_PKG_SHA256=baadde0b63fe35c6ef71d912041dd6b16dcb8177627028e00b43e172f2c08992

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    $CXX $CXXFLAGS \
        src/*.cpp \
        -o vano
}

termux_step_make_install() {
    install -Dm755 vano $TERMUX_PREFIX/bin/vano
}
