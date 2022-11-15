TERMUX_PKG_HOMEPAGE=https://matt.ucc.asn.au/dropbear/dropbear.html
TERMUX_PKG_DESCRIPTION="Small SSH server and client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.83
TERMUX_PKG_SRCURL=https://matt.ucc.asn.au/dropbear/releases/dropbear-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=bc5a121ffbc94b5171ad5ebe01be42746d50aa797c9549a4639894a16749443b
TERMUX_PKG_DEPENDS="termux-auth, zlib"
TERMUX_PKG_SUGGESTS="openssh-sftp-server"
TERMUX_PKG_CONFLICTS="openssh"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syslog --disable-utmp --disable-utmpx --disable-wtmp --disable-static"
# Avoid linking to libcrypt for server password authentication:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
# build a multi-call binary & enable progress info in 'scp'
TERMUX_PKG_EXTRA_MAKE_ARGS="MULTI=1 SCPPROGRESS=1"

termux_step_pre_configure() {
	export LIBS="-ltermux-auth"
}

termux_step_post_make_install() {
	ln -sf "dropbearmulti" "${TERMUX_PREFIX}/bin/ssh"
}

termux_step_create_debscripts() {
	{
	echo "#!$TERMUX_PREFIX/bin/sh"
	echo "mkdir -p $TERMUX_PREFIX/etc/dropbear"
	echo "for a in rsa ecdsa ed25519; do"
	echo "	KEYFILE=$TERMUX_PREFIX/etc/dropbear/dropbear_\${a}_host_key"
	echo "	test ! -f \$KEYFILE && dropbearkey -t \$a -f \$KEYFILE"
	echo "done"
	echo "exit 0"
	} > postinst
	chmod 0755 postinst
}
