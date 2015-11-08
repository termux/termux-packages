TERMUX_PKG_HOMEPAGE=http://netpbm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Toolkit for manipulation of graphic images, including conversion of images between a variety of different formats"
# The netpbm releases are described at http://netpbm.sourceforge.net/release.html
# and are divided among (1) Development, (2) Advanced, (3) Stable and (4) Super Stable.
# Only Super Stable is distributed as a tar ball, but is outdated and does not compile with modern libpng.
# So use revisions from http://svn.code.sf.net/p/netpbm/code/advanced for packages.
_SVN_REVISION=2654
TERMUX_PKG_VERSION=${_SVN_REVISION}
TERMUX_PKG_DEPENDS="libpng, libxml2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_MAKE_PROCESSES=1

termux_step_extract_package () {
	svn co -r $_SVN_REVISION http://svn.code.sf.net/p/netpbm/code/advanced $TERMUX_PKG_SRCDIR
}

termux_step_configure () {
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
	echo "LDFLAGS = $LDFLAGS" >> config.mk
	echo "STATICLIB_TOO = n" >> config.mk
	echo "INTTYPES_H = <inttypes.h>" >> config.mk
	export STRIPPROG=$STRIP

	echo "CC_FOR_BUILD = cc" >> config.mk
	echo "LD_FOR_BUILD = cc" >> config.mk
	echo "CFLAGS_FOR_BUILD = " >> config.mk
	echo "LDFLAGS_FOR_BUILD = " >> config.mk
}

termux_step_make_install () {
	rm -Rf /tmp/netpbm
	make -j 1 package pkgdir=/tmp/netpbm
	./installnetpbm
}
