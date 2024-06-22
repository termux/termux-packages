TERMUX_PKG_HOMEPAGE=https://wiki.termux.com/wiki/Termux:API
TERMUX_PKG_DESCRIPTION="Termux API commands (install also the Termux:API app)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.58.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-api-package/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4c8913a18e14662f5a09d74a210ba6c9b843a45c609cc7ebf081e16b0a27e601
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="bash, util-linux, termux-am (>= 0.8.0)"
