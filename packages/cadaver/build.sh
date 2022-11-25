TERMUX_PKG_HOMEPAGE=https://notroj.github.io/cadaver/
TERMUX_PKG_DESCRIPTION="A command-line WebDAV client for Unix"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_SRCURL=https://notroj.github.io/cadaver/cadaver-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=46cff2f3ebd32cd32836812ca47bcc75353fc2be757f093da88c0dd8f10fd5f6
TERMUX_PKG_DEPENDS="libneon, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-nls
"
