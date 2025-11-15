TERMUX_PKG_HOMEPAGE=https://vlang.io/
TERMUX_PKG_DESCRIPTION="V programming language compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.12
TERMUX_PKG_SRCURL=https://github.com/vlang/v/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=65e3579df61ae0a7314aa5f0c7eb3b0b9b45170a0275e392e9c168be23046e89
TERMUX_PKG_DEPENDS="build-essential, clang, make, libgc-dev, libexecinfo-dev, libatomic1"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm700 v "$TERMUX_PREFIX/bin/v"
}
