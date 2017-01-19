TERMUX_PKG_HOMEPAGE=http://www.underbit.com/products/mad/
TERMUX_PKG_DESCRIPTION="MAD is a high-quality MPEG audio decoder"
TERMUX_PKG_VERSION=0.15.1b
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://ftp.mars.org/pub/mpeg/libmad-${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		# See https://www.mars.org/pipermail/mad-dev/2013-July/001433.html
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-fpm=default"
	fi
}

termux_post_configure() {
	cd $TERMUX_PKG_SRCDIR
	sed -i -e 's/-force-mem//g' Makefile
}
