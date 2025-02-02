TERMUX_PKG_HOMEPAGE=https://github.com/tux-mind/libbthread
TERMUX_PKG_DESCRIPTION="replace pthread_cancel and related bionic holes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1"
TERMUX_PKG_SRCURL=git+https://github.com/tux-mind/libbthread
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libtool, autoconf, automake"

termux_step_configure() {
autoreconf -i
bash configure --prefix=$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX
}
