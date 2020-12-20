TERMUX_PKG_HOMEPAGE=https://aria2.github.io
TERMUX_PKG_DESCRIPTION="Download utility supporting HTTP/HTTPS, FTP, BitTorrent and Metalink"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.35.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/aria2/aria2/releases/download/release-${TERMUX_PKG_VERSION}/aria2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1e2b7fd08d6af228856e51c07173cfcf987528f1ac97e04c5af4a47642617dfd
TERMUX_PKG_DEPENDS="libc++, c-ares, openssl, libxml2, zlib"
# sqlite3 is only used for loading cookies from firefox or chrome:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-openssl
--without-gnutls
--without-libuv
--without-sqlite3
--without-libssh2
ac_cv_func_basename=yes
ac_cv_func_getaddrinfo=yes
ac_cv_func_gettimeofday=yes
ac_cv_func_sleep=yes
ac_cv_func_usleep=yes
ac_cv_search_getaddrinfo=no
"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "arm" ]; then
		CXXFLAGS="${CFLAGS/-Oz/-Os}"
	fi
}
