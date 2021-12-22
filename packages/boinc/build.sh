TERMUX_PKG_HOMEPAGE=https://boinc.berkeley.edu/
TERMUX_PKG_DESCRIPTION="Open-source software for volunteer computing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.16.16
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/BOINC/boinc/archive/client_release/${TERMUX_PKG_VERSION:0:4}/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d5656a9f8ed1048936a5764270848b892d63f27bdb863d0ace447f1eaae6002
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libcurl, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-server
--disable-manager
"

TERMUX_PKG_CONFFILES="etc/boinc-client.conf"

termux_step_pre_configure() {
	# for benchmark purposes
	CFLAGS="${CFLAGS/-Oz/-Os}"
	CXXFLAGS="${CXXFLAGS/-Oz/-Os}"
	LDFLAGS+=" -landroid-shmem"
	./_autosetup
}
