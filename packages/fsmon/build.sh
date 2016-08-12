TERMUX_PKG_HOMEPAGE=https://www.nowsecure.com
TERMUX_PKG_DESCRIPTION="FileSystem Monitor"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/nowsecure/fsmon/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME="fsmon-$TERMUX_PKG_VERSION"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_make() {
	make CC=${CC} FANOTIFY_CFLAGS="-DHAVE_FANOTIFY=1 -DHAVE_SYS_FANOTIFY=0"
}

termux_step_make_install() {
	make install PREFIX="${prefix}"
}
