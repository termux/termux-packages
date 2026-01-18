TERMUX_PKG_HOMEPAGE=https://indigo-dc.github.io/udocker
TERMUX_PKG_DESCRIPTION="A basic user tool to execute simple docker containers in batch or interactive systems without root privileges."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.17
TERMUX_PKG_SRCURL=https://github.com/indigo-dc/udocker/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=76713c1e8ea3f0f412144fda51b38a6e309d1fe29e85de8f678626d42e9e04a1
TERMUX_PKG_DEPENDS="curl, proot, python, resolv-conf"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--prefix=$TERMUX_PREFIX"
