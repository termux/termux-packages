TERMUX_PKG_HOMEPAGE=http://www.libressl.org/
TERMUX_PKG_DESCRIPTION="Library implementing the TLS protocol as well as general purpose cryptography functions"
TERMUX_PKG_DEPENDS="ca-certificates"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_SRCURL=http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-openssldir=$TERMUX_PREFIX/etc/tls"
TERMUX_PKG_CONFLICTS="openssl"
# etc/tls/cert.pem is provided by ca-certificates:
TERMUX_PKG_RM_AFTER_INSTALL="etc/tls/cert.pem"

CPPFLAGS+=" -DNO_SYSLOG"
