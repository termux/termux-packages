TERMUX_PKG_HOMEPAGE=http://netpbm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Toolkit for manipulation of graphic images of different formats"
TERMUX_PKG_LICENSE="LGPL-2.0"
# The netpbm releases are described at http://netpbm.sourceforge.net/release.html
# and are divided among (1) Development, (2) Advanced, (3) Stable and (4) Super Stable.
# Only Super Stable is distributed as a tar ball, but is outdated and does not compile with modern libpng.
# So use revisions from http://svn.code.sf.net/p/netpbm/code/advanced for packages.
TERMUX_PKG_VERSION=3094
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=2f4d8c245f174e391a4cf2418075c06532aee8a5fcc8dbbb8f2e7012cd9d52a4
TERMUX_PKG_SRCURL=https://dl.bintray.com/termux/upstream/netpbm-advanced-r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libpng, libxml2, libjpeg-turbo, libtiff, zlib"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	# Put the android libpng-config script in the path (before the host one):
	TERMUX_PKG_LIBPNG_CONFIG_DIR=$TERMUX_PKG_TMPDIR/libpng-config
	mkdir -p $TERMUX_PKG_LIBPNG_CONFIG_DIR
	cp $TERMUX_PREFIX/bin/libpng-config $TERMUX_PKG_LIBPNG_CONFIG_DIR/
	export PATH=$TERMUX_PKG_LIBPNG_CONFIG_DIR:$PATH

	# See $SRC/doc/INSTALL about netpbm build system. For automatic builds it recommends just copying config.mk.in
	cd $TERMUX_PKG_SRCDIR
	cp config.mk.in config.mk
	echo "AR = $AR" >> config.mk
	echo "RANLIB = $RANLIB" >> config.mk
	echo "CC = $CC" >> config.mk
	echo "CFLAGS = $CFLAGS" >> config.mk
	echo "CFLAGS_SHLIB = -fPIC" >> config.mk
	echo "LDFLAGS = $LDFLAGS" >> config.mk
	echo "STATICLIB_TOO = n" >> config.mk
	echo "INTTYPES_H = <inttypes.h>" >> config.mk
	export STRIPPROG=$STRIP

	echo "CC_FOR_BUILD = cc" >> config.mk
	echo "LD_FOR_BUILD = cc" >> config.mk
	echo "CFLAGS_FOR_BUILD = " >> config.mk
	echo "LDFLAGS_FOR_BUILD = " >> config.mk
	echo "JPEGLIB = ${TERMUX_PREFIX}/lib/libjpeg.so" >> config.mk
	echo "TIFFLIB = ${TERMUX_PREFIX}/lib/libtiff.so" >> config.mk
	echo "TIFFLIB_NEEDS_Z = N" >> config.mk

	cp $TERMUX_PKG_BUILDER_DIR/standardppmdfont.c lib/
}

termux_step_make_install() {
	rm -Rf /tmp/netpbm
	make -j 1 package pkgdir=/tmp/netpbm
	./installnetpbm
}
