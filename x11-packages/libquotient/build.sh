TERMUX_PKG_HOMEPAGE="https://quotient-im.github.io/libQuotient"
TERMUX_PKG_DESCRIPTION="A Qt library to write cross-platform clients for Matrix"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.6.1"
TERMUX_PKG_SRCURL="https://github.com/quotient-im/libQuotient/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ac0fe5df480fa893d3e16da626bf5028c944e9b41f504f6fe0fe49273247d636
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libolm, openssl, qt6-qtbase, qtkeychain"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
