TERMUX_PKG_HOMEPAGE=http://mdocml.bsd.lv/
TERMUX_PKG_DESCRIPTION="Man page viewer from the mandoc toolset"
TERMUX_PKG_VERSION=1.13.4
TERMUX_PKG_BUILD_REVISION=3
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/mdocml-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="less,libandroid-glob,libsqlite"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL="share/examples"

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	LDFLAGS+=" -landroid-glob"
	echo "PREFIX=\"$TERMUX_PREFIX\"" > configure.local
	echo "MANDIR=\"$TERMUX_PREFIX/share/man\"" >> configure.local
	echo "CFLAGS=\"$CFLAGS -DNULL=0 $CPPFLAGS\"" >> configure.local
	echo "LDFLAGS=\"$LDFLAGS\"" >> configure.local
	for HAVING in HAVE_FGETLN HAVE_MMAP HAVE_STRLCAT HAVE_STRLCPY; do
		echo "$HAVING=1" >> configure.local
	done
	echo "HAVE_MANPATH=0" >> configure.local
	echo "HAVE_SQLITE3=1" >> configure.local
}

termux_step_create_debscripts () {
	echo "interest $TERMUX_PREFIX/share/man" > triggers

	echo "makewhatis -Q" > postinst
	echo "exit 0" >> postinst
}
