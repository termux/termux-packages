TERMUX_PKG_HOMEPAGE=http://mama.indstate.edu/users/ice/tree/
TERMUX_PKG_DESCRIPTION="displays an indented directory tree, in color
 Tree is a recursive directory listing command that produces a depth indented
 listing of files, which is colorized ala dircolors if the LS_COLORS environment
 variable is set and output is to tty."
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_MAINTAINER=$(echo "Gert Scholten <gscholt at gmail dot com>" | sed 's/\sat\s/@/' | sed 's/\sdot\s/./')
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
