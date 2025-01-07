TERMUX_PKG_HOMEPAGE=https://mdocml.bsd.lv/
TERMUX_PKG_DESCRIPTION="Man page viewer from the mandoc toolset"
TERMUX_PKG_LICENSE="ISC, BSD 2-Clause, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.14.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://mdocml.bsd.lv/snapshots/mandoc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c
TERMUX_PKG_DEPENDS="less,libandroid-glob,zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="share/examples"

termux_step_pre_configure() {
	CPPFLAGS+=" -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD"
	LDFLAGS+=" -landroid-glob"
	echo "PREFIX=\"$TERMUX_PREFIX\"" > configure.local
	echo "CC=\"$CC\"" >> configure.local
	echo "MANDIR=\"$TERMUX_PREFIX/share/man\"" >> configure.local
	echo "CFLAGS=\"$CFLAGS -std=c99 -DNULL=0 $CPPFLAGS\"" >> configure.local
	echo "LDFLAGS=\"$LDFLAGS\"" >> configure.local
	for HAVING in HAVE_FGETLN HAVE_MMAP HAVE_STRLCAT HAVE_STRLCPY HAVE_SYS_ENDIAN HAVE_ENDIAN HAVE_NTOHL HAVE_NANOSLEEP HAVE_O_DIRECTORY HAVE_ISBLANK; do
		echo "$HAVING=1" >> configure.local
	done
	echo "HAVE_MANPATH=0" >> configure.local
	echo "HAVE_SQLITE3=1" >> configure.local
}

termux_step_create_debscripts() {
	[ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && echo "interest-noawait $TERMUX_PREFIX/share/man" > triggers

	echo "#!$TERMUX_PREFIX/bin/sh" >> postinst
	echo "makewhatis -Q" >> postinst
	echo "exit 0" >> postinst
}
