TERMUX_PKG_HOMEPAGE=https://ssdeep-project.github.io/ssdeep/
TERMUX_PKG_DESCRIPTION="A program for computing context triggered piecewise hashes (CTPH)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/ssdeep-project/ssdeep/archive/refs/tags/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d96f667a8427ad96da197884574c7ca8c7518a37d9ac8593b6ea77e7945720a4
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-auto-search
"

termux_step_pre_configure() {
	autoreconf -fi
}
