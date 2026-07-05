TERMUX_PKG_HOMEPAGE=https://github.com/therealviren/vano
TERMUX_PKG_DESCRIPTION="Vano text editor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="therealviren"
TERMUX_PKG_VERSION=v1.4.12
TERMUX_PKG_SRCURL=git+https://github.com/therealviren/vano.git
TERMUX_PKG_GIT_BRANCH=v1.4.12

termux_step_configure() {
    termux_setup_cmake
    cmake -S "$TERMUX_PKG_SRCDIR" \
        -B "$TERMUX_PKG_BUILDDIR" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX"
}

termux_step_make() {
    cmake --build "$TERMUX_PKG_BUILDDIR" --parallel "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
    cmake --install "$TERMUX_PKG_BUILDDIR"
}                                        