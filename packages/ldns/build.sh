TERMUX_PKG_HOMEPAGE=http://www.nlnetlabs.nl/projects/ldns/
TERMUX_PKG_DESCRIPTION="Library for simplifying DNS programming and supporting recent and experimental RFCs"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_VERSION=1.6.17
TERMUX_PKG_SRCURL=http://www.nlnetlabs.nl/downloads/ldns/ldns-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b88e059452118e8949a2752a55ce59bc71fa5bc414103e17f5b6b06f9bcc8cd
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=$TERMUX_PREFIX"
TERMUX_PKG_RM_AFTER_INSTALL="bin/ldns-config share/man/man1/ldns-config.1"
