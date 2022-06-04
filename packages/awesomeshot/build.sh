TERMUX_PKG_HOMEPAGE=https://github.com/mayTermux/awesomeshot
TERMUX_PKG_DESCRIPTION="A command-line screenshot tool written in bash"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/mayTermux/awesomeshot/archive/refs/tags/v.${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=abed90173c6679c2891939091ddfe56fcafa566ed6dae7ed8a77a4545ad6c332
TERMUX_PKG_DEPENDS="bash, bc, imagemagick, inotify-tools, termux-api"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
