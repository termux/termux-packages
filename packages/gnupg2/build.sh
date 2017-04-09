TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_VERSION=2.1.20
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=24cf9a69369be64a9f6f8cc11a1be33ab7780ad77a6a1b93719438f49f69960d
TERMUX_PKG_DEPENDS="libassuan,libbz2,libgcrypt,libksba,libnpth,readline,pinentry"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ldap --disable-sqlite"
# Remove non-english help files and man pages shipped with the gnupg (1) package:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt share/man/man1/gpg-zip.1 share/man/man7/gnupg.7"

termux_step_pre_configure() {
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}
