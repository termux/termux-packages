TERMUX_PKG_HOMEPAGE=http://www.httrack.com
TERMUX_PKG_DESCRIPTION="It allows you to download a World Wide Web site from the Internet"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.51.0"
TERMUX_PKG_SRCURL=https://github.com/xroche/httrack/releases/download/${TERMUX_PKG_VERSION}/httrack-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1daa7ec0153ec16e6bea809c2d8829ceddf0e06f74471fa0528ffbf20275f5f1
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
