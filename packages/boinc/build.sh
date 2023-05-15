TERMUX_PKG_HOMEPAGE=https://boinc.berkeley.edu/
TERMUX_PKG_DESCRIPTION="Open-source software for volunteer computing"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.22.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/BOINC/boinc/archive/client_release/${TERMUX_PKG_VERSION:0:4}/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0a62f24dce703779e04f91f5c613974dcb98df61adb599b7076d461eb26dfbaf
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-shmem, libc++, libcurl, openssl, zlib"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-server
--disable-manager
"

# etc/boinc-client.conf is not for Android, extra hooks needed to work
TERMUX_PKG_RM_AFTER_INSTALL="
etc/boinc-client.conf
"

termux_step_pre_configure() {
	export CFLAGS+=" -fPIC"
	export CXXFLAGS+=" -fPIC"
	export LDFLAGS+=" -landroid-shmem -landroid-execinfo $(${CC} -print-libgcc-file-name)"
	./_autosetup
}

termux_step_post_make_install() {
	install -Dm644 "${TERMUX_PKG_SRCDIR}/client/scripts/boinc.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/boinc"
}
