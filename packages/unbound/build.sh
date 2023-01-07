TERMUX_PKG_HOMEPAGE=https://unbound.net/
TERMUX_PKG_DESCRIPTION="A validating, recursive, caching DNS resolver"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://nlnetlabs.nl/downloads/unbound/unbound-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dcbc95d7891d9f910c66e4edc9f1f2fde4dea2eec18e3af9f75aed44a02f1341
TERMUX_PKG_DEPENDS="libevent, libexpat, libnghttp2, openssl, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

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

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	build-pip install wheel

	export PYTHON_SITE_PKG=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/run"
}
