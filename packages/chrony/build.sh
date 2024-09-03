TERMUX_PKG_HOMEPAGE=https://chrony-project.org/
TERMUX_PKG_DESCRIPTION="chrony is an implementation of the Network Time Protocol (NTP)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6"
TERMUX_PKG_SRCURL=https://chrony-project.org/releases/chrony-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9adad4a5014420fc52b695896556fdfb49709dc7cd72d7f688d9eb85d5a274d5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-shmem, libcap, libgnutls, libnettle, libnss, libtomcrypt, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--chronyvardir=${TERMUX_PREFIX}/var/lib/chrony"

termux_step_pre_configure() {
	LDFLAGS="${LDFLAGS/-Wl,--as-needed/} -landroid-glob -landroid-shmem"
}
