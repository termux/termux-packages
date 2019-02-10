TERMUX_PKG_HOMEPAGE=https://mdocml.bsd.lv/
TERMUX_PKG_DESCRIPTION="Man page viewer from the mandoc toolset"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.14.4
TERMUX_PKG_SHA256=24eb72103768987dcc63b53d27fdc085796330782f44b3b40c4660b1e1ee9b9c
TERMUX_PKG_SRCURL=http://mdocml.bsd.lv/snapshots/mandoc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="less,libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_RM_AFTER_INSTALL="share/examples"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	echo "PREFIX=\"$TERMUX_PREFIX\"" > configure.local
	echo "CC=\"$CC\"" >> configure.local
	echo "MANDIR=\"$TERMUX_PREFIX/share/man\"" >> configure.local
	echo "CFLAGS=\"$CFLAGS -std=c99 -DNULL=0 $CPPFLAGS\"" >> configure.local
	echo "LDFLAGS=\"$LDFLAGS\"" >> configure.local
	for HAVING in HAVE_FGETLN HAVE_MMAP HAVE_STRLCAT HAVE_STRLCPY HAVE_SYS_ENDIAN HAVE_ENDIAN HAVE_NTOHL HAVE_NANOSLEEP HAVE_O_DIRECTORY; do
		echo "$HAVING=1" >> configure.local
	done
	echo "HAVE_MANPATH=0" >> configure.local
	echo "HAVE_SQLITE3=1" >> configure.local
}

termux_step_create_debscripts() {
	echo "interest-noawait $TERMUX_PREFIX/share/man" > triggers
	
	echo "#!$TERMUX_PREFIX/bin/sh" >> postinst
	echo "makewhatis -Q" >> postinst
	echo "exit 0" >> postinst
}
