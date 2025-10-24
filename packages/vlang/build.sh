TERMUX_PKG_HOMEPAGE=https://vlang.io/
TERMUX_PKG_DESCRIPTION="V programming language compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ilyas-ozt"
TERMUX_PKG_VERSION="0.1.0"
TERMUX_PKG_GIT_URL=https://github.com/vlang/v
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="clang, libandroid-execinfo, libgc, libgc-static, make"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    make
}

termux_step_make_install() {
    install -Dm700 v "$TERMUX_PREFIX/bin/v"
    install -Dm644 LICENSE "$TERMUX_PREFIX/share/doc/vlang/LICENSE"
    [ -f README.md ] && install -Dm644 README.md "$TERMUX_PREFIX/share/doc/vlang/README.md"
}
