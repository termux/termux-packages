TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/gpgme/
TERMUX_PKG_DESCRIPTION="Library designed to make access to GnuPG easier"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_DEPENDS="gnupg (>= 2.2.9-1), libassuan, libgpg-error"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libgpg-error-dev"
TERMUX_PKG_VERSION=1.12.0
TERMUX_PKG_SHA256=b4dc951c3743a60e2e120a77892e9e864fb936b2e58e7c77e8581f4d050e8cd8
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-${TERMUX_PKG_VERSION}.tar.bz2
# Use "--disable-gpg-test" to avoid "No rule to make target `../../src/libgpgme-pthread.la":
# Use "--enable-languages=no" to only build the C library.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gpg-test
--enable-languages=no
--with-gpg=$TERMUX_PREFIX/bin/gpg2
--without-g13
--without-gpgconf
--without-gpgsm
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/gpgme-config"
