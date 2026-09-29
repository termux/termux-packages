TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org/
TERMUX_PKG_DESCRIPTION="Library handling the communication with Apple's Tatsu Signing Server (TSS)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libtatsu/releases/download/${TERMUX_PKG_VERSION}/libtatsu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=536fa228b14f156258e801a7f4d25a3a9dd91bb936bf6344e23171403c57e440
TERMUX_PKG_DEPENDS="libcurl (>= 7.0), libplist"
