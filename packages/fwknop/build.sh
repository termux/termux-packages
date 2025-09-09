TERMUX_PKG_HOMEPAGE=https://www.cipherdyne.org/fwknop/
TERMUX_PKG_DESCRIPTION="fwknop: Single Packet Authorization > Port Knocking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.cipherdyne.org/fwknop/download/fwknop-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a4ec7c22dd90dd684f9f7b96d3a901c4131ec8c7a3b9db26d0428513f6774c64
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gpgme"
TERMUX_PKG_BREAKS="fwknop-dev"
TERMUX_PKG_REPLACES="fwknop-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-server
--with-gpgme
--with-gpg=$TERMUX_PREFIX/bin/gpg2
"

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}
