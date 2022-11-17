TERMUX_PKG_HOMEPAGE=https://github.com/kaniini/libucontext
TERMUX_PKG_DESCRIPTION="A library which provides the ucontext.h C API"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=https://github.com/kaniini/libucontext/archive/refs/tags/libucontext-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=937fba9d0beebd7cf957b79979b19fe3a29bb9c4bfd25e869477d7154bbf8fd3
TERMUX_PKG_EXTRA_MAKE_ARGS="ARCH=$TERMUX_ARCH"
