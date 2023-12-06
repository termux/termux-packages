TERMUX_PKG_HOMEPAGE=https://chrony-project.org/
TERMUX_PKG_DESCRIPTION="chrony is an implementation of the Network Time Protocol (NTP)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@marek22k"
TERMUX_PKG_VERSION="4.5"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://chrony-project.org/releases/chrony-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=19fe1d9f4664d445a69a96c71e8fdb60bcd8df24c73d1386e02287f7366ad422
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-shmem, libcap, libgnutls, libnettle, libnss, libtomcrypt, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--chronyvardir=${TERMUX_PREFIX}/var/lib/chrony"

termux_step_pre_configure() {
	LDFLAGS="${LDFLAGS/-Wl,--as-needed/} -landroid-glob -landroid-shmem"
}
