TERMUX_PKG_HOMEPAGE=https://github.com/nowsecure/fsmon
TERMUX_PKG_DESCRIPTION="Filesystem monitor with fanotify and inotify backends"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.5
TERMUX_PKG_SRCURL=https://github.com/nowsecure/fsmon/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eb99cfb242bea9fc5bde66e67f4324bd71100d17b1672e4e52db14b9a5e2900a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make FANOTIFY_CFLAGS="-DHAVE_FANOTIFY=1 -DHAVE_SYS_FANOTIFY=0"
}
