TERMUX_PKG_HOMEPAGE=https://github.com/mayTermux/awesomeshot
TERMUX_PKG_DESCRIPTION="A command-line screenshot tool written in bash"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_SRCURL=https://github.com/mayTermux/awesomeshot/archive/refs/tags/v.${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=60a850a8d7015f45795622ff58d7a7445055f38f81f0bfea0e870974e454bf30
TERMUX_PKG_DEPENDS="bash, termux-api, imagemagick, inotify-tools, bc"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
