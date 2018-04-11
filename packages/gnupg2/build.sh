TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_VERSION=2.2.6
TERMUX_PKG_SHA256=e64d8c5fa2d05938a5080cb784a98ac21be0812f2a26f844b18f0d6a0e711984
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libassuan,libbz2,libgcrypt,libksba,libsqlite,libnpth,readline,pinentry,libgpg-error"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ldap
--enable-gpg-is-gpg2
--enable-sqlite
--enable-tofu
"
# Remove non-english help files and man pages shipped with the gnupg (1) package:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt share/man/man1/gpg-zip.1 share/man/man7/gnupg.7"

termux_step_pre_configure() {
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}
