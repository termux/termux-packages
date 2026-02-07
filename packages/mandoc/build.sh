TERMUX_PKG_HOMEPAGE=https://mdocml.bsd.lv/
TERMUX_PKG_DESCRIPTION="Man page viewer from the mandoc toolset"
TERMUX_PKG_LICENSE="ISC, BSD 2-Clause, BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION=1.14.6
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=http://mdocml.bsd.lv/snapshots/mandoc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c
TERMUX_PKG_DEPENDS="less, libandroid-glob, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="man"
TERMUX_PKG_REPLACES="man"
TERMUX_PKG_PROVIDES="man"
TERMUX_PKG_CONFFILES="etc/man.conf"
TERMUX_PKG_RM_AFTER_INSTALL="share/examples"

termux_step_pre_configure() {
	CPPFLAGS+=" -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD"
	LDFLAGS+=" -landroid-glob"
	# Stop trying to be smarter than you should be shellcheck.
	# We did mean CFLAGS not CPPFLAGS in that line.
	# shellcheck disable=SC2153
	{
		echo "PREFIX=\"$TERMUX_PREFIX\""
		echo "CC=\"$CC\""
		echo "MANDIR=\"$TERMUX_PREFIX/share/man\""
		echo "CFLAGS=\"$CFLAGS -std=c99 -DNULL=0 $CPPFLAGS\""
		echo "LDFLAGS=\"$LDFLAGS\""
		for HAVING in 'HAVE_STRLCAT' 'HAVE_STRLCPY' 'HAVE_SYS_ENDIAN' 'HAVE_ENDIAN' 'HAVE_NTOHL' 'HAVE_NANOSLEEP' 'HAVE_O_DIRECTORY' 'HAVE_ISBLANK'; do
			echo "$HAVING=1"
		done
	} > configure.local
}

termux_step_post_massage() {
	mkdir -p etc
	echo "manpath	$TERMUX_PREFIX/share/man" > etc/man.conf
}

termux_step_create_debscripts() {
	if [[ "$TERMUX_PACKAGE_FORMAT" == "debian" ]]; then
		echo "interest-noawait $TERMUX_PREFIX/share/man" > triggers
		{
			echo "#!$TERMUX_PREFIX/bin/sh"
			echo "makewhatis -Q"
			echo "exit 0"
		} > postinst
	fi
}
