TERMUX_PKG_HOMEPAGE=https://memcached.org/
TERMUX_PKG_DESCRIPTION="Free & open source, high-performance, distributed memory object caching system"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.32"
TERMUX_PKG_SRCURL=https://www.memcached.org/files/memcached-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4ab234219865191e8d1ba57a2f9167d8b573248fa4ff00b4d8296be13d24a82c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libevent, libsasl"
TERMUX_PKG_BREAKS="memcached-dev"
TERMUX_PKG_REPLACES="memcached-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static --enable-sasl --disable-coverage"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"

	export ac_cv_c_endian=little

	# Fix SASL configuration path
	perl -p -i -e "s#/etc/sasl#$TERMUX_PREFIX/etc/sasl#" $TERMUX_PKG_BUILDDIR/sasl_defs.c

	# getsubopt() taken from https://github.com/lxc/lxc/blob/master/src/include/getsubopt.c
	cp $TERMUX_PKG_BUILDER_DIR/getsubopt.c $TERMUX_PKG_SRCDIR
	cp $TERMUX_PKG_BUILDER_DIR/getsubopt.h $TERMUX_PKG_SRCDIR

	autoreconf -vfi
}
