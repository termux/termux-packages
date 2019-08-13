TERMUX_PKG_HOMEPAGE=https://repo.or.cz/alpine.git
TERMUX_PKG_DESCRIPTION="Fast, easy to use email client"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=2.21.99999
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/alpine-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=229de9f673430190055207f8980205186ed6f73873f1ae6e1467d9d78e0f9dec
TERMUX_PKG_DEPENDS="libcrypt, ncurses, openssl-tool"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--with-c-client-target=lnx
--without-krb5
--without-ldap
--without-pthread
--without-tcl
--with-system-pinerc=${TERMUX_PREFIX}/etc/pine.conf
--with-passfile=$TERMUX_ANDROID_HOME/.pine-passfile
"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export TCC=$CC
	export TRANLIB=$RANLIB
	export SPELLPROG=${TERMUX_PREFIX}/bin/hunspell
	export alpine_SSLVERSION=old
	export TPATH=$PATH

	export LIBS="-lcrypt -llog"

	# To get S_IREAD and friends:
	CPPFLAGS+=" -D__USE_BSD"

	cp $TERMUX_PKG_BUILDER_DIR/pine.conf $TERMUX_PREFIX/etc/pine.conf

	touch $TERMUX_PKG_SRCDIR/imap/lnxok
}

termux_step_post_configure() {
	cd pith
	$CC_FOR_BUILD help_c_gen.c -o help_c_gen
	$CC_FOR_BUILD help_h_gen.c -o help_h_gen
	touch -d "next hour" help_c_gen help_h_gen
}
termux_step_create_debscripts() {

	echo "#!$TERMUX_PREFIX/bin/sh" >> postinst
	echo "if [ ! -e $TERMUX_ANDROID_HOME/.alpine-smime/.pwd/MasterPassword.crt ] && [ ! -e $HOME/.alpine-smime/.pwd/MasterPassword.key ]; then" >> postinst
	echo "echo 'warning making a passwordless masterpasword file'" >> postinst
	echo "mkdir -p \$HOME/.alpine-smime/public \$HOME/.alpine-smime/.pwd \$HOME/.alpine-smime/private \$HOME/.alpine-smime/ca" >> postinst
	echo "openssl req -x509 -newkey rsa:2048 -keyout \$HOME/.alpine-smime/.pwd/MasterPassword.key -out \$HOME/.alpine-smime/.pwd/MasterPassword.crt -days 10000 -nodes -subj '/C=US/ST=dont/L=use/O=this Name/OU=for/CN=anything.com.termux'" >> postinst
	echo "touch \$HOME/.pine-passfile" >> postinst
	echo "fi" >> postinst
}

