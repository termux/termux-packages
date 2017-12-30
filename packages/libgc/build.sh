TERMUX_PKG_HOMEPAGE=http://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_RM_AFTER_INSTALL="share/gc lib/libatomic_ops.so lib/libatomic_ops_gpl.so lib/libgc.a lib/libcord.a"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-static --with-libatomic-ops=no "
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_VERSION=7.6.2
TERMUX_PKG_SHA256=bd112005563d787675163b5afff02c364fc8deb13a99c03f4e80fdf6608ad41e
TERMUX_PKG_SRCURL=https://github.com/ivmai/bdwgc/releases/download/v$TERMUX_PKG_VERSION/gc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"

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
	make install 
	cd libatomic_ops
	make install
	rm $TERMUX_PREFIX/lib/libgc.a $TERMUX_PREFIX/lib/libatomic_ops.so $TERMUX_PREFIX/lib/libatomic_ops_gpl.so \
		$TERMUX_PREFIX/lib/libgc.la $TERMUX_PREFIX/lib/libatomic_ops.la $TERMUX_PREFIX/lib/libatomic_ops_gpl.la
}
termux_step_post_massage() {
	rm lib/*.la
}
