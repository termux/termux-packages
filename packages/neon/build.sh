TERMUX_PKG_HOMEPAGE=https://notroj.github.io/neon/
TERMUX_PKG_DESCRIPTION="Neon is an HTTP/1.1 and WebDAV client library, with a C interface."
TERMUX_PKG_LICENSE_FILE="src/COPYING.LIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.32.1
TERMUX_PKG_SRCURL=https://notroj.github.io/neon/neon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=05c54bc115030c89e463a4fb28d3a3f8215879528ba5ca70d676d3d21bf3af52
TERMUX_PKG_DEPENDS="libxml2"
TERMUX_PKG_SUGGESTS="libproxy, pakchois"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--prefix=$PREFIX --with-ssl --enable-shared"
termux_step_pre_configure() {
	#This step is needed if xmlto is not available
	cd ${TERMUX_PKG_SRCDIR} && sed 's/\(install-\(html\|man\):\).*/\1/' -i Makefile.in 
}
