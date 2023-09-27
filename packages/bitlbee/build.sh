TERMUX_PKG_HOMEPAGE=https://www.bitlbee.org/
TERMUX_PKG_DESCRIPTION="An IRC to other chat networks gateway"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6-1
TERMUX_PKG_SRCURL=https://github.com/bitlbee/bitlbee/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81c6357fe08a8941221472e3790e2b351e3a8a41f9af0cf35395fdadbc8ac6cb
TERMUX_PKG_DEPENDS="ca-certificates, glib, libgcrypt, libgnutls"

termux_step_pre_configure() {
	LDFLAGS+=" -lgcrypt"
}

termux_step_configure_autotools() {
	sh "$TERMUX_PKG_SRCDIR/configure" \
		--prefix=$TERMUX_PREFIX \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_make_install() {
	make install-etc install-dev
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/lib/bitlbee
	EOF
}
