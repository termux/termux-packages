TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org/
TERMUX_PKG_DESCRIPTION="Library handling the communication with Apple's Tatsu Signing Server (TSS)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libtatsu/releases/download/${TERMUX_PKG_VERSION}/libtatsu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=08094e58364858360e1743648581d9bad055ba3b06e398c660e481ebe0ae20b3
TERMUX_PKG_DEPENDS="libcurl (>= 7.0), libplist"
