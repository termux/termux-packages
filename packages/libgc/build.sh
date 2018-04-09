TERMUX_PKG_HOMEPAGE=http://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_VERSION=7.6.4
TERMUX_PKG_SHA256=b94c1f2535f98354811ee644dccab6e84a0cf73e477ca03fb5a3758fb1fecd1c
TERMUX_PKG_SRCURL=https://github.com/ivmai/bdwgc/releases/download/v$TERMUX_PKG_VERSION/gc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cplusplus --enable-static --with-libatomic-ops=no"
TERMUX_PKG_KEEP_STATIC_LIBRARIES="true"

termux_step_post_extract_package () {
	LIBATOMIC_VERSION=7.6.2
	LIBATOMIC_FILE=libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	termux_download \
		https://github.com/ivmai/libatomic_ops/releases/download/v${LIBATOMIC_VERSION}/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE \
		219724edad3d580d4d37b22e1d7cb52f0006d282d26a9b8681b560a625142ee6
	tar xf $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE
	mv libatomic_ops-${LIBATOMIC_VERSION} libatomic_ops
	./autogen.sh
}
termux_step_make_install() {
	cd libatomic_ops
	make install
	cd ../
	make install
	rm $TERMUX_PREFIX/lib/libatomic_ops*.so $TERMUX_PREFIX/lib/libatomic_ops*.la
}
termux_step_post_massage() {
	rm $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libgc.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libgc.la
	rm $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libcord.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libcord.la
	rm $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libgccpp.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libgccpp.la
}
