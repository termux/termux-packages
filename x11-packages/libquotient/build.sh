TERMUX_PKG_HOMEPAGE="https://quotient-im.github.io/libQuotient"
TERMUX_PKG_DESCRIPTION="A Qt library to write cross-platform clients for Matrix"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.6"
TERMUX_PKG_SRCURL="https://github.com/quotient-im/libQuotient/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=67a286a36343b9b3a02e95d52985f8042aee70f8a12a7513b9f5cb68e1a85721
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libolm, openssl, qt6-qtbase, qtkeychain"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
