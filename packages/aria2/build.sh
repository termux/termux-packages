TERMUX_PKG_HOMEPAGE=https://aria2.github.io
TERMUX_PKG_DESCRIPTION="Multi-protocol & multi-source command-line download utility supporting HTTP/HTTPS, FTP, BitTorrent and Metalink"
TERMUX_PKG_VERSION=1.30.0
TERMUX_PKG_SRCURL=https://github.com/aria2/aria2/releases/download/release-${TERMUX_PKG_VERSION}/aria2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bf6c5366d11d2a6038c8e19f01f9b874041793aaf317e0206120e3e8c9c431f6
TERMUX_PKG_DEPENDS="c-ares, openssl, libxml2"
# sqlite3 is only used for loading cookies from firefox or chrome:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-openssl --without-gnutls --without-libuv --without-sqlite3 ac_cv_search_getaddrinfo=no ac_cv_func_getaddrinfo=yes ac_cv_func_gettimeofday=yes ac_cv_func_sleep=yes ac_cv_func_usleep=yes ac_cv_func_basename=yes"

termux_step_pre_configure () {
	# Run autoreconf since we have patched Makefile.am:
	cd $TERMUX_PKG_SRCDIR
	autoreconf
}
