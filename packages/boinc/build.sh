TERMUX_PKG_HOMEPAGE=https://boinc.berkeley.edu/
TERMUX_PKG_DESCRIPTION="Open-source software for volunteer computing"
TERMUX_PKG_LICENSE="GPL-3.0"
_MAJOR_VERSION=7.14
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://github.com/BOINC/boinc/archive/client_release/${_MAJOR_VERSION}/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=489e0300ecb1b095f86adb3b03f9bf04f2e1944e08fd9e74a5aa9ee298036d1c
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libcurl, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

TERMUX_MAKE_PROCESSES=1

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
