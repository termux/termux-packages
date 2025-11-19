TERMUX_PKG_HOMEPAGE=http://www.httrack.com
TERMUX_PKG_DESCRIPTION="It allows you to download a World Wide Web site from the Internet"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.49.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/h/httrack/httrack_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=2d2ddfe8d1264024862abe801819e177ecbb1eb417dcf4650a054c671f3b7ff9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="httrack-data, libandroid-execinfo, libiconv, openssl, zlib"
TERMUX_PKG_BREAKS="httrack-dev"
TERMUX_PKG_REPLACES="httrack-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--docdir=$TERMUX_PREFIX/share/httrack/html
--with-zlib=$TERMUX_PREFIX
LIBS=-liconv
"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_configure() {
	make clean
}
