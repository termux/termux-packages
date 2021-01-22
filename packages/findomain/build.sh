TERMUX_PKG_HOMEPAGE=https://findomain.app/
TERMUX_PKG_DESCRIPTION="Findomain is the fastest subdomain enumerator and the only one written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://github.com/Findomain/Findomain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=49efa3c55a1bf73c06e212630e20da4080313ce6d0e3d29d13544af8f2151f0b
TERMUX_PKG_BUILD_IN_SRC=true
# Compilation error related to assembly code.
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
