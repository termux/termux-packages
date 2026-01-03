TERMUX_PKG_HOMEPAGE=https://github.com/coturn/coturn
TERMUX_PKG_DESCRIPTION="Open-source implementation of TURN and STUN server"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.6.2
TERMUX_PKG_SRCURL=https://github.com/coturn/coturn/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=13f2a38b66cffb73d86b5ed24acba4e1371d738d758a6039e3a18f0c84c176ad
TERMUX_PKG_DEPENDS="libc++, libevent, libsqlite, openssl"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_pre_configure() {
	# getdomainname is not available on Android 7.0
	CPPFLAGS+=" -DTURN_NO_GETDOMAINNAME=1"
}
