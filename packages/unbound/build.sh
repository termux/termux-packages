TERMUX_PKG_HOMEPAGE=https://unbound.net/
TERMUX_PKG_DESCRIPTION="A validating, recursive, caching DNS resolver"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17.1
TERMUX_PKG_SRCURL=https://nlnetlabs.nl/downloads/unbound/unbound-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ee4085cecce12584e600f3d814a28fa822dfaacec1f94c84bfd67f8a5571a5f4
TERMUX_PKG_DEPENDS="libevent, libexpat, libnghttp2, openssl, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

# `pythonmodule` makes core lib/libunbound.so depend on python. Do not enable it.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_chown=no
ac_cv_func_chroot=no
ac_cv_func_getpwnam=no
--enable-event-api
--enable-ipsecmod
--enable-linux-ip-local-port-range
--enable-tfo-server
--with-libevent=$TERMUX_PREFIX
--with-libexpat=$TERMUX_PREFIX
--without-libhiredis
--without-libmnl
--with-pyunbound
--without-pythonmodule
--with-libnghttp2=$TERMUX_PREFIX
--with-ssl=$TERMUX_PREFIX
--with-pidfile=$TERMUX_PREFIX/var/run/unbound.pid
--with-username=
"

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/run"
}
