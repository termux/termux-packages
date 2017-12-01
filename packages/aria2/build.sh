TERMUX_PKG_HOMEPAGE=https://aria2.github.io
TERMUX_PKG_DESCRIPTION="Download utility supporting HTTP/HTTPS, FTP, BitTorrent and Metalink"
TERMUX_PKG_VERSION=1.33.1
TERMUX_PKG_SHA256=2539e4844f55a1f1f5c46ad42744335266053a69162e964d9a2d80a362c75e1b
TERMUX_PKG_SRCURL=https://github.com/aria2/aria2/releases/download/release-${TERMUX_PKG_VERSION}/aria2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="c-ares, openssl, libxml2"
# sqlite3 is only used for loading cookies from firefox or chrome:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-openssl
--without-gnutls
--without-libuv
--without-sqlite3
ac_cv_func_basename=yes
ac_cv_func_getaddrinfo=yes
ac_cv_func_gettimeofday=yes
ac_cv_func_sleep=yes
ac_cv_func_usleep=yes
ac_cv_search_getaddrinfo=no
"
