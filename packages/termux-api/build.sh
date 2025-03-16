TERMUX_PKG_HOMEPAGE=https://wiki.termux.com/wiki/Termux:API
TERMUX_PKG_DESCRIPTION="Termux API commands (install also the Termux:API app)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.59.0
TERMUX_PKG_SRCURL=https://github.com/termux/termux-api-package/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c2f68cc3bd848bc386c64b06bffdb5fe96f14820017c3e80c0afc77f36a8789e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="bash, util-linux, termux-am (>= 0.8.0)"
