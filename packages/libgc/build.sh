TERMUX_PKG_HOMEPAGE=http://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
# The latest release 7.4.2 is too old for aarch64, use a master snapshot until 7.5:
TERMUX_PKG_VERSION=7.4.`date "+%Y%m%d%H%M"`
TERMUX_PKG_SRCURL=https://github.com/ivmai/bdwgc/archive/master.zip
TERMUX_PKG_FOLDERNAME=bdwgc-master
TERMUX_PKG_NO_SRC_CACHE=yes
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"

# Avoid defining structs already defined in api level 21 or beyond
CFLAGS+=" -DGC_DONT_DEFINE_LINK_MAP"

termux_step_post_extract_package () {
	LIBATOMIC_VERSION=7.4.2
	LIBATOMIC_FILE=libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	test ! -f $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE && curl -o $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	cd $TERMUX_PKG_SRCDIR
	tar xf $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE
	mv libatomic_ops-${LIBATOMIC_VERSION} libatomic_ops

	./autogen.sh
}
