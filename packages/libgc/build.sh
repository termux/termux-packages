TERMUX_PKG_HOMEPAGE=http://www.hboehm.info/gc/
TERMUX_PKG_DESCRIPTION="Library providing the Boehm-Demers-Weiser conservative garbage collector"
# The latest release 7.4.2 is too old for aarch64, use the version
# https://github.com/ivmai/bdwgc/tree/c861ec3d1825b5bb450d20bf9091562fa8a81a4d
# from 2016-0-114 21:34 for now.
TERMUX_PKG_VERSION=7.4.201601142134
TERMUX_PKG_SRCURL=https://github.com/ivmai/bdwgc/archive/c861ec3d1825b5bb450d20bf9091562fa8a81a4d.zip
TERMUX_PKG_FOLDERNAME=bdwgc-c861ec3d1825b5bb450d20bf9091562fa8a81a4d
TERMUX_PKG_RM_AFTER_INSTALL="share/gc"

# Avoid defining structs already defined in api level 21 or beyond
CFLAGS+=" -DGC_DONT_DEFINE_LINK_MAP"

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	autoconf
}

termux_step_post_extract_package () {
	LIBATOMIC_VERSION=7.4.2
	LIBATOMIC_FILE=libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	test ! -f $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE && curl -o $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-${LIBATOMIC_VERSION}.tar.gz
	cd $TERMUX_PKG_SRCDIR
	tar xf $TERMUX_PKG_CACHEDIR/$LIBATOMIC_FILE
	mv libatomic_ops-${LIBATOMIC_VERSION} libatomic_ops

	./autogen.sh
}
