TERMUX_PKG_HOMEPAGE=https://www.cipherdyne.org/fwknop/
TERMUX_PKG_DESCRIPTION="fwknop: Single Packet Authorization > Port Knocking"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.cipherdyne.org/fwknop/download/fwknop-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f6c09bec97ed8e474a98ae14f9f53e1bcdda33393f20667b6af3fb6bb894ca77
TERMUX_PKG_DEPENDS="gpgme"
TERMUX_PKG_BREAKS="fwknop-dev"
TERMUX_PKG_REPLACES="fwknop-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-server
--with-gpgme
--with-gpg=$TERMUX_PREFIX/bin/gpg2
"
