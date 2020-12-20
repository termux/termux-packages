TERMUX_PKG_HOMEPAGE=https://findomain.app/
TERMUX_PKG_DESCRIPTION="Findomain is the fastest subdomain enumerator and the only one written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.5
TERMUX_PKG_SRCURL=https://github.com/Findomain/Findomain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=31182a63f2d2002e5dc99e8f809157c18e660a9964cbbc9faa249e131493c635
TERMUX_PKG_BUILD_IN_SRC=true
# Compilation error related to assembly code.
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
