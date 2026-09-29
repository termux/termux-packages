TERMUX_PKG_HOMEPAGE=https://github.com/kaniini/libucontext
TERMUX_PKG_DESCRIPTION="A library which provides the ucontext.h C API"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.2"
TERMUX_PKG_SRCURL=https://github.com/kaniini/libucontext/archive/refs/tags/libucontext-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9230397327bbf580e04c9456d1509e9af19599c7f6deca7f75969ece6e9d598e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dfreestanding=true"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+(.\d+)?"
