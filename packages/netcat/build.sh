TERMUX_PKG_HOMEPAGE=http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/nc.1
TERMUX_PKG_DESCRIPTION="Utility for reading from and writing to connections using TCP or UDP"
TERMUX_PKG_VERSION=1.103
_COMMIT=b023a43765b15f0b0fd5b52b7d8021f515c59c23
TERMUX_PKG_SRCURL=https://github.com/android/platform_external_netcat/archive/${_COMMIT}.zip
TERMUX_PKG_FOLDERNAME=platform_external_netcat-$_COMMIT

termux_step_make () {
	return
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR
	CFLAGS+=" -DANDROID=1"
	$CC $CFLAGS $LDFLAGS *.c -o $TERMUX_PREFIX/bin/nc

	cp $TERMUX_PKG_BUILDER_DIR/nc.1 $TERMUX_PREFIX/share/man/man1/
}
