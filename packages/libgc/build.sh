TERMUX_PKG_HOMEPAGE=http://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_VERSION=7.6.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.hboehm.info/gc/gc_source/gc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90
TERMUX_PKG_RM_AFTER_INSTALL="share/gc lib/libatomic_ops.so lib/libatomic_ops_gpl.so lib/libgc.a lib/libcord.a"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-static --with-libatomic-ops=no "
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_CLANG=no
termux_step_post_extract_package () {
	LIBATOMIC_VERSION=7.4.8
	LIBATOMIC_FILE=libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	test ! -f $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE && \
		termux_download \
		https://github.com/ivmai/libatomic_ops/releases/download/v${LIBATOMIC_VERSION}/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE \
		c405d5524b118c197499bc311b8ebe18f7fe47fc820f2c2fcefde1753fbd436a	
	tar xf $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE
	mv libatomic_ops-${LIBATOMIC_VERSION} libatomic_ops
	./autogen.sh
}
	
termux_step_pre_configure() { 
# revert this patch as it causes threading errors but only on i686
if [ "$TERMUX_ARCH" = "i686" ]; then
	patch -p1 -R < $TERMUX_PKG_BUILDER_DIR/pthread_stop_world.c.patch
fi
}
termux_step_make_install() {
	make install 
	cd libatomic_ops
	make install
}
termux_step_post_massage() {
	rm lib/*.la
}
