TERMUX_PKG_HOMEPAGE=http://www.gnupg.org/related_software/gpgme/
TERMUX_PKG_DESCRIPTION="Library designed to make access to GnuPG easier"
TERMUX_PKG_DEPENDS="gnupg, libassuan"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-${TERMUX_PKG_VERSION}.tar.bz2
# Use "--disable-gpg-test" to avoid "No rule to make target `../../src/libgpgme-pthread.la":
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gpgconf --without-gpgsm --without-g13 --disable-gpg-test --with-gpg=$TERMUX_PREFIX/bin/gpg"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gpgme-config"
