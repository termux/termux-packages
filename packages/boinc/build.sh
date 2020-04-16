TERMUX_PKG_HOMEPAGE=https://boinc.berkeley.edu/
TERMUX_PKG_DESCRIPTION="Open-source software for volunteer computing"
TERMUX_PKG_LICENSE="GPL-3.0"
_MAJOR_VERSION=7.16
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/BOINC/boinc/archive/client_release/${_MAJOR_VERSION}/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=caa567da8d3eb50859efe2eeba1c23c7b27d3b0f15b548136e75302713b25303
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
