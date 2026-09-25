TERMUX_PKG_HOMEPAGE=http://www.httrack.com
TERMUX_PKG_DESCRIPTION="It allows you to download a World Wide Web site from the Internet"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.50.4"
TERMUX_PKG_SRCURL=https://github.com/xroche/httrack/releases/download/${TERMUX_PKG_VERSION}/httrack-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f97dbb96d110681b4349912c8bc5c4011a6c227a7d4294ea1d4f0093baea51b6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="httrack-data, libandroid-execinfo, libiconv, openssl, zlib"
TERMUX_PKG_BREAKS="httrack-dev"
TERMUX_PKG_REPLACES="httrack-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-mptcp
--docdir=$TERMUX_PREFIX/share/httrack
--with-zlib=$TERMUX_PREFIX
LIBS=-liconv
"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Prevent warnings as error
	sed -i "s/-Werror/-Wno-error/g" configure.ac
	autoreconf -fiv
}

termux_step_post_configure() {
	make clean
}
