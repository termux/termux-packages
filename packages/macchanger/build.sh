TERMUX_PKG_HOMEPAGE=https://github.com/alobbs/macchanger
TERMUX_PKG_DESCRIPTION="Utility that makes the maniputation of MAC addresses of network interfaces easier"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_SRCURL=https://github.com/alobbs/macchanger/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=macchanger-${TERMUX_PKG_VERSION}
# TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
}
