TERMUX_PKG_HOMEPAGE=http://mdocml.bsd.lv/
TERMUX_PKG_DESCRIPTION="Man page viewer from the mandoc toolset"
TERMUX_PKG_VERSION=1.13.3
TERMUX_PKG_SRCURL=http://mdocml.bsd.lv/snapshots/mdocml-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="less,libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL="share/examples"

termux_step_post_extract_package () {
	cd $TERMUX_PKG_SRCDIR
	LDFLAGS+=" -landroid-glob"
	echo "PREFIX=\"$TERMUX_PREFIX\"" > configure.local
	echo "MANDIR=\"$TERMUX_PREFIX/share/man\"" >> configure.local
	echo "CFLAGS=\"$CFLAGS -DNULL=0 $CPPFLAGS $LDFLAGS\"" >> configure.local
	for HAVING in HAVE_FGETLN HAVE_MMAP HAVE_STRLCAT HAVE_STRLCPY; do
		echo "$HAVING=1" >> configure.local
	done
	echo "HAVE_MANPATH=0" >> configure.local
	echo "HAVE_SQLITE3=0" >> configure.local
}

termux_step_make_install () {
	make -j 1 install
	echo "_whatdb         $TERMUX_PREFIX/share/man/mandoc.db" > $TERMUX_PREFIX/etc/man.conf
}
