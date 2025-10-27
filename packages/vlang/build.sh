TERMUX_PKG_HOMEPAGE=https://vlang.io/
TERMUX_PKG_DESCRIPTION="V programming language compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.12
TERMUX_PKG_SRCURL=https://github.com/vlang/v/archive/refs/tags/weekly.2025.43.tar.gz
TERMUX_PKG_SHA256=4aefc5b0228815735011b4f49edd4877b5712b7a7539aaadd6ea8c2ca514f1a9
TERMUX_PKG_DEPENDS="clang, libandroid-execinfo, libgc"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm700 v "$TERMUX_PREFIX/bin/v"
    termux_step_install_license
}
