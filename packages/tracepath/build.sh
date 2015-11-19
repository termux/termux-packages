TERMUX_PKG_HOMEPAGE=https://github.com/iputils/iputils
TERMUX_PKG_DESCRIPTION="Tool to trace the network path to a remote host"
TERMUX_PKG_VERSION=20150815
TERMUX_PKG_SRCURL=https://github.com/iputils/iputils/archive/s${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=iputils-s$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libidn"

termux_step_make () {
	continue
}

termux_step_make_install () {
	$CC $CFLAGS $LDFLAGS -lidn -o $TERMUX_PREFIX/bin/tracepath tracepath.c
	$CC $CFLAGS $LDFLAGS -lidn -o $TERMUX_PREFIX/bin/tracepath6 tracepath6.c
	local MANDIR=$TERMUX_PREFIX/share/man/man8
	mkdir -p $MANDIR
	cp $TERMUX_PKG_BUILDER_DIR/tracepath.8 $MANDIR/
	(cd $MANDIR && ln -f -s tracepath.8 tracepath6.8)
}
