TERMUX_PKG_HOMEPAGE=https://boinc.berkeley.edu/
TERMUX_PKG_DESCRIPTION="Open-source software for volunteer computing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=7.16.7
TERMUX_PKG_SRCURL=https://github.com/BOINC/boinc/archive/client_release/${TERMUX_PKG_VERSION:0:4}/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=38130d532031e75701eee910da64b9eb837e5bfeff9979dbb200c37146be3fed
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libcurl, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-server
--enable-client
--disable-manager
"

TERMUX_PKG_CONFFILES="etc/boinc-client.conf"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"
	./_autosetup
}
