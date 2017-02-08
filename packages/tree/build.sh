TERMUX_PKG_HOMEPAGE=http://mama.indstate.edu/users/ice/tree/
TERMUX_PKG_DESCRIPTION="Recursive directory lister producing a depth indented listing of files"
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_MAINTAINER="Gert Scholten @gscholt"
TERMUX_PKG_SRCURL=http://mama.indstate.edu/users/ice/tree/src/tree-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	make \
		CC="$CC" \
		CFLAGS="$CFLAGS $CPPFLAGS -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64" \
		LDFLAGS="$LDFLAGS" \
		OBJS="tree.o unix.o html.o xml.o json.o hash.o color.o strverscmp.o"
}

termux_step_make_install () {
	make install \
		prefix="$TERMUX_PREFIX" \
		MANDIR="$TERMUX_PREFIX/share/man/man1"
}
