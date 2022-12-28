TERMUX_PKG_HOMEPAGE=https://github.com/mayTermux/awesomeshot
TERMUX_PKG_DESCRIPTION="A command-line screenshot tool written in bash"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/mayTermux/awesomeshot/archive/refs/tags/v.${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5daefb4c02743503e08764fb604e6a811e4ce09a301fafe7cd00a43418a687b1
TERMUX_PKG_DEPENDS="bash, bc, imagemagick, inotify-tools, termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
