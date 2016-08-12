TERMUX_PKG_HOMEPAGE=https://github.com/nowsecure/fsmon
TERMUX_PKG_DESCRIPTION="Filesystem monitor with fanotify and inotify backends"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/nowsecure/fsmon/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME="fsmon-$TERMUX_PKG_VERSION"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	make FANOTIFY_CFLAGS="-DHAVE_FANOTIFY=1 -DHAVE_SYS_FANOTIFY=0"
}
