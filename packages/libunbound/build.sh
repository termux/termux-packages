TERMUX_PKG_HOMEPAGE=https://unbound.net/
TERMUX_PKG_DESCRIPTION="A validating, recursive, caching DNS resolver"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://nlnetlabs.nl/downloads/unbound/unbound-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=44e7b53e008a6dcaec03032769a212b46ab5c23c105284aa05a4f3af78e59cdb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libevent, libnghttp2, libngtcp2, openssl, resolv-conf"
TERMUX_PKG_BUILD_DEPENDS="python, swig"
TERMUX_PKG_BREAKS="unbound (<< 1.17.1-1)"
TERMUX_PKG_REPLACES="unbound (<< 1.17.1-1)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS="swig"

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
--with-libngtcp2=$TERMUX_PREFIX
--with-ssl=$TERMUX_PREFIX
--with-pidfile=$TERMUX_PREFIX/var/run/unbound.pid
--with-username=
"

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/run"
}
