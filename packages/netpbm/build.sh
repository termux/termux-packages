TERMUX_PKG_HOMEPAGE=http://netpbm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Toolkit for manipulation of graphic images of different formats"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:10.73.38
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/netpbm/super_stable/${TERMUX_PKG_VERSION:2}/netpbm-${TERMUX_PKG_VERSION:2}.tgz
TERMUX_PKG_SHA256=0bbf8ef88413ed286e9b040685c44758857e86ccb266ccf9643ee29807e961de
TERMUX_PKG_DEPENDS="libpng, libxml2, libjpeg-turbo, libtiff, zlib"
TERMUX_PKG_BREAKS="netpbm-dev"
TERMUX_PKG_REPLACES="netpbm-dev"
TERMUX_PKG_BUILD_IN_SRC=true

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
