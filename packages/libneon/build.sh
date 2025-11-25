TERMUX_PKG_HOMEPAGE=https://notroj.github.io/neon/
TERMUX_PKG_DESCRIPTION="An HTTP/1.1 and WebDAV client library, with a C interface"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.36.0"
TERMUX_PKG_SRCURL=https://notroj.github.io/neon/neon-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=70cc7f2aeebde263906e185b266e04e0de92b38e5f4ecccbf61e8b79177c2f07
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libexpat, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ssl=openssl
--with-expat
"
