TERMUX_PKG_HOMEPAGE=https://github.com/mdbtools/mdbtools
TERMUX_PKG_DESCRIPTION="A set of programs to help you extract data from Microsoft Access files in various settings"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/mdbtools/mdbtools/releases/download/v${TERMUX_PKG_VERSION}/mdbtools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3446e1d71abdeb98d41e252777e67e1909b186496fda59f98f67032f7fbcd955
TERMUX_PKG_DEPENDS="glib, libiconv, readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-iodbc=$TERMUX_PREFIX"
