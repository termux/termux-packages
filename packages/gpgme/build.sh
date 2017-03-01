TERMUX_PKG_HOMEPAGE=http://www.gnupg.org/related_software/gpgme/
TERMUX_PKG_DESCRIPTION="Library designed to make access to GnuPG easier"
TERMUX_PKG_DEPENDS="gnupg2, libassuan"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=596097257c2ce22e747741f8ff3d7e24f6e26231fa198a41b2a072e62d1e5d33
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
TERMUX_PKG_RM_AFTER_INSTALL="bin/gpgme-config"
