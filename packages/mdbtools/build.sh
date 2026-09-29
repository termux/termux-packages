TERMUX_PKG_HOMEPAGE=https://github.com/mdbtools/mdbtools
TERMUX_PKG_DESCRIPTION="A set of programs to help you extract data from Microsoft Access files in various settings"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mdbtools/mdbtools/releases/download/v${TERMUX_PKG_VERSION}/mdbtools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff9c425a88bc20bf9318a332eec50b17e77896eef65a0e69415ccb4e396d1812
TERMUX_PKG_DEPENDS="glib, libiconv, readline, libiodbc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-iodbc=$TERMUX_PREFIX"
