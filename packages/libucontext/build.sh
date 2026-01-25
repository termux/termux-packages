TERMUX_PKG_HOMEPAGE=https://github.com/kaniini/libucontext
TERMUX_PKG_DESCRIPTION="A library which provides the ucontext.h C API"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5"
TERMUX_PKG_SRCURL=https://github.com/kaniini/libucontext/archive/refs/tags/libucontext-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b3ca8d7d3e5c926a90ddb691f8a52ccb364069a745304a40c29f3b0d39b80c93
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dfreestanding=true"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+(.\d+)?"
