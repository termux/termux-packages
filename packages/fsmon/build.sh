TERMUX_PKG_HOMEPAGE=https://github.com/nowsecure/fsmon
TERMUX_PKG_DESCRIPTION="Filesystem monitor with fanotify and inotify backends"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_SRCURL=https://github.com/nowsecure/fsmon/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=37ea1c83297976f5c7058637a328150dea57743d5eb55ebfc3a8075d262d67c2
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make FANOTIFY_CFLAGS="-DHAVE_FANOTIFY=1 -DHAVE_SYS_FANOTIFY=0"
}
