TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/gpgme/
TERMUX_PKG_DESCRIPTION="Library designed to make access to GnuPG easier"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17.0
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4ed3f50ceb7be2fce2c291414256b20c9ebf4c03fddb922c88cda99c119a69f5
TERMUX_PKG_DEPENDS="gnupg (>= 2.2.9-1), libassuan, libgpg-error"
TERMUX_PKG_BREAKS="gpgme-dev"
TERMUX_PKG_REPLACES="gpgme-dev"
# Use "--disable-gpg-test" to avoid "No rule to make target `../../src/libgpgme-pthread.la":
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gpg-test
--enable-languages=cpp
--with-gpg=$TERMUX_PREFIX/bin/gpg2
--without-g13
--without-gpgconf
--without-gpgsm
"
