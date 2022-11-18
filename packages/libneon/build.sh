TERMUX_PKG_HOMEPAGE=https://notroj.github.io/neon/
TERMUX_PKG_DESCRIPTION="An HTTP/1.1 and WebDAV client library, with a C interface"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.32.4
TERMUX_PKG_SRCURL=https://notroj.github.io/neon/neon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b1e2120e4ae07df952c4a858731619733115c5f438965de4fab41d6bf7e7a508
TERMUX_PKG_DEPENDS="libexpat, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ssl=openssl
--with-expat
"
