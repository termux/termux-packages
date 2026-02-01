TERMUX_PKG_HOMEPAGE=http://mama.indstate.edu/users/ice/tree/
TERMUX_PKG_DESCRIPTION="Recursive directory lister producing a depth indented listing of files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.1"
TERMUX_PKG_SRCURL="https://gitlab.com/OldManProgrammer/unix-tree/-/archive/${TERMUX_PKG_VERSION}/unix-tree-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ac3cda918492fc4dd7833745a9fd431fa976c35e682fd824656bfe21d8b51a69
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make \
		CC="$CC" \
		CFLAGS="$CFLAGS $CPPFLAGS -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64" \
		LDFLAGS="$LDFLAGS"
}

termux_step_make_install() {
	make install \
		PREFIX="$TERMUX_PREFIX" \
		MANDIR="$TERMUX_PREFIX/share/man/man1"
}
