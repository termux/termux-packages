TERMUX_PKG_HOMEPAGE=http://www.bzip.org/
TERMUX_PKG_DESCRIPTION="BZ2 format compression library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.8
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/bzip2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=47fd74b2ff83effad0ddf62074e6fad1f6b4a77a96e121ab421c20a216371a1f
TERMUX_PKG_BREAKS="libbz2-dev"
TERMUX_PKG_REPLACES="libbz2-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	# bzip2 does not use configure. But place man pages at correct path:
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" $TERMUX_PKG_SRCDIR/Makefile
}

termux_step_make() {
	# bzip2 uses a separate makefile for the shared library
	make -f Makefile-libbz2_so
}

termux_step_post_make_install() {
	# Clean out statically linked binaries and libs and replace them with shared ones:
	rm -f $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/libbz2*
	rm -f $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/{bzcat,bunzip2}
	install -m700 bzip2-shared $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/bzip2
	install -m600 libbz2.so.${TERMUX_PKG_VERSION} $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	(cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib && ln -s libbz2.so.${TERMUX_PKG_VERSION} libbz2.so.1.0)
	(cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib && ln -s libbz2.so.${TERMUX_PKG_VERSION} libbz2.so)
	(cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin && ln -s bzip2 bzcat)
	(cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin && ln -s bzip2 bunzip2)
	# bzgrep should be enough so remove bz{e,f}grep
	rm -f $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/bz{e,f}grep \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man1/bz{e,f}grep.1
}
