TERMUX_PKG_HOMEPAGE=http://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_VERSION=7.6.4
TERMUX_PKG_SHA256=b94c1f2535f98354811ee644dccab6e84a0cf73e477ca03fb5a3758fb1fecd1c
TERMUX_PKG_SRCURL=https://github.com/ivmai/bdwgc/releases/download/v$TERMUX_PKG_VERSION/gc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"

termux_step_post_extract_package () {
	LIBATOMIC_VERSION=7.6.4
	LIBATOMIC_FILE=libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	termux_download \
		https://github.com/ivmai/libatomic_ops/releases/download/v${LIBATOMIC_VERSION}/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE \
		5b823d5a685dd70caeef8fc50da7d763ba7f6167fe746abca7762e2835b3dd4e
	tar xf $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE
	mv libatomic_ops-${LIBATOMIC_VERSION} libatomic_ops
	./autogen.sh
}
