TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.16"
TERMUX_PKG_SRCURL="https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=05144040fedb828ced2a6bafa2c4a0479ee4cceacf3b6d68ccc75b175ac13b7e
TERMUX_PKG_DEPENDS="libassuan, libbz2, libgcrypt, libgnutls, libgpg-error, libksba, libnpth, libsqlite, readline, pinentry, resolv-conf, zlib"
TERMUX_PKG_CONFLICTS="gnupg2 (<< 2.2.9-1), dirmngr (<< 2.2.17-1)"
TERMUX_PKG_REPLACES="gnupg2 (<< 2.2.9-1), dirmngr (<< 2.2.17-1)"
TERMUX_PKG_SUGGESTS="scdaemon"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-ldap
--enable-sqlite
--enable-tofu
ac_cv_path_YAT2M=$TERMUX_PKG_HOSTBUILD_DIR/doc/yat2m
"
# Remove non-english help files and man pages shipped with the gnupg (1) package:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt share/man/man1/gpg-zip.1 share/man/man7/gnupg.7"

# gnupg 2.5.5 needs a newer yat2m version than ubuntu 24.04
# provides. Therefore download also libgpg-error sources and hostbuild
# the tool.
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	LIBGPG_ERROR_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libgpg-error/build.sh; echo $TERMUX_PKG_VERSION)
	LIBGPG_ERROR_SRCURL=$(. $TERMUX_SCRIPTDIR/packages/libgpg-error/build.sh; echo $TERMUX_PKG_SRCURL)
	LIBGPG_ERROR_SHA256=$(. $TERMUX_SCRIPTDIR/packages/libgpg-error/build.sh; echo $TERMUX_PKG_SHA256)

	termux_download \
		$LIBGPG_ERROR_SRCURL \
		$TERMUX_PKG_CACHEDIR/libgpg-error-${LIBGPG_ERROR_VERSION}.tar.bz2 \
		$LIBGPG_ERROR_SHA256
	tar xf $TERMUX_PKG_CACHEDIR/libgpg-error-${LIBGPG_ERROR_VERSION}.tar.bz2
	./libgpg-error-${LIBGPG_ERROR_VERSION}/configure
	make -C doc yat2m
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/doc/:$PATH"
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	ln -sf gpg gpg2
}
