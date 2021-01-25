TERMUX_PKG_HOMEPAGE=https://findomain.app/
TERMUX_PKG_DESCRIPTION="Findomain is the fastest subdomain enumerator and the only one written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://github.com/Findomain/Findomain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7bbedd088a64557876ccd7e7da92f1f8a5b67cfed1aaf335cd5d2b2a5f1824ad
TERMUX_PKG_BUILD_IN_SRC=true
# Compilation error related to assembly code.
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
