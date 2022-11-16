TERMUX_PKG_HOMEPAGE="https://github.com/nelhage/reptyr"
TERMUX_PKG_DESCRIPTION="Tool for reparenting a running program to a new terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_SRCURL=https://github.com/nelhage/reptyr/archive/refs/tags/reptyr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b442fbb80a1003b1985974c6fc9eeb8124a43a9bf014ae6af8cde0ca5e587731
TERMUX_PKG_BUILD_DEPENDS="bash-completion"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
