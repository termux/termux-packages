TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/gpgme/
TERMUX_PKG_DESCRIPTION="Library designed to make access to GnuPG easier"
TERMUX_PKG_DEPENDS="gnupg2, libassuan, libgpg-error"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libgpg-error-dev"
TERMUX_PKG_VERSION=1.11.1
TERMUX_PKG_SHA256=2d1b111774d2e3dd26dcd7c251819ce4ef774ec5e566251eb9308fa7542fbd6f
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
