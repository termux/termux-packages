TERMUX_PKG_HOMEPAGE=https://findomain.app/
TERMUX_PKG_DESCRIPTION="Findomain is the fastest subdomain enumerator and the only one written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.1.4
TERMUX_PKG_SRCURL=https://github.com/Findomain/Findomain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dd193f3b2d81b05769efbf2a2c7af7479395617204343c84fb5d7e1b0bec9d83
TERMUX_PKG_BUILD_IN_SRC=true
# Compilation error related to assembly code.
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
