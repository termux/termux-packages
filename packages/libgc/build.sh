TERMUX_PKG_HOMEPAGE=http://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
TERMUX_PKG_VERSION=7.6.0
TERMUX_PKG_SRCURL=http://www.hboehm.info/gc/gc_source/gc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"

termux_step_post_extract_package () {
	LIBATOMIC_VERSION=7.4.4
	LIBATOMIC_FILE=libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	test ! -f $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE && \
		termux_download \
		http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz \
		$TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE \
		bf210a600dd1becbf7936dd2914cf5f5d3356046904848dcfd27d0c8b12b6f8f
	tar xf $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE
	mv libatomic_ops-${LIBATOMIC_VERSION} libatomic_ops
	./autogen.sh
}
