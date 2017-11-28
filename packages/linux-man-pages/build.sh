TERMUX_PKG_HOMEPAGE=https://www.kernel.org/doc/man-pages/
TERMUX_PKG_DESCRIPTION="Man pages for linux kernel and C library interfaces"
TERMUX_PKG_VERSION=4.13
TERMUX_PKG_SHA256=d5c005c5b653248ab6680560de00ea8572ff39e48a57bd5be1468d986a0631bf
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/linux/docs/man-pages/man-pages-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="man"
TERMUX_PKG_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX"
# man.7 and mdoc.7 is included with mandoc:
# getconf man page included with the getconf package:
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1 share/man/man8 share/man/man7/man.7 share/man/man7/mdoc.7 share/man/man1p/getconf.1p"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
# Problems with changing permissions of non-built files
TERMUX_MAKE_PROCESSSES=1

termux_step_pre_configure() {
	# Bundle posix man pages in same package:
	local _POSIX_TARFILE=man-pages-posix-2013-a.tar.xz
	if [ ! -f $TERMUX_PKG_CACHEDIR/$_POSIX_TARFILE ]; then
		termux_download \
			https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/$_POSIX_TARFILE \
			$TERMUX_PKG_CACHEDIR/$_POSIX_TARFILE \
			19633a5c75ff7deab35b1d2c3d5b7748e7bd4ef4ab598b647bb7e7f60b90a808

	fi
	mkdir -p $TERMUX_PKG_TMPDIR/man-pages-posix
	cd $TERMUX_PKG_TMPDIR/man-pages-posix
	tar xf $TERMUX_PKG_CACHEDIR/$_POSIX_TARFILE
	cd man-pages-posix-2013-a
	make install
}
