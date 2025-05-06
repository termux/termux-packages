TERMUX_PKG_HOMEPAGE=https://github.com/nowsecure/fsmon
TERMUX_PKG_DESCRIPTION="Filesystem monitor with fanotify and inotify backends"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.8"
TERMUX_PKG_SRCURL=https://github.com/nowsecure/fsmon/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b7f9a7310d7721c58e6e5bc432c5b2099be55b374ab9bf5f639420d2b9e0ab0a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make FANOTIFY_CFLAGS="-DHAVE_FANOTIFY=1 -DHAVE_SYS_FANOTIFY=0"
}
