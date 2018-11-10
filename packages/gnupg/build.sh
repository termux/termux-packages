TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_VERSION=2.2.10
TERMUX_PKG_SHA256=799dd37a86a1448732e339bd20440f4f5ee6e69755f6fd7a73ee8af30840c915
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libassuan,libbz2,libgcrypt,libksba,libsqlite,libnpth,readline,pinentry,libgpg-error"
TERMUX_PKG_CONFLICTS="gnupg2 (<< 2.2.9-1)"
TERMUX_PKG_REPLACES="gnupg2 (<< 2.2.9-1)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ldap
--enable-sqlite
--enable-tofu
"
# Remove non-english help files and man pages shipped with the gnupg (1) package:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt share/man/man1/gpg-zip.1 share/man/man7/gnupg.7"

termux_step_pre_configure() {
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	ln -sf gpg gpg2
}
