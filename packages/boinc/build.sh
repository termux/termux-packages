TERMUX_PKG_HOMEPAGE=https://boinc.berkeley.edu/
TERMUX_PKG_DESCRIPTION="Open-source software for volunteer computing"
TERMUX_PKG_LICENSE="GPL-3.0"
_MAJOR_VERSION=7.16
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.5
TERMUX_PKG_SRCURL=https://github.com/BOINC/boinc/archive/client_release/${_MAJOR_VERSION}/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=33db60991b253e717c6124cce4750ae7729eaab4e54ec718b9e37f87012d668a
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
	CPPFLAGS+=" -DANDROID"
	LDFLAGS+=" -llog"
	./_autosetup
}
