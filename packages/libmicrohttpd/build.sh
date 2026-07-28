TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/libmicrohttpd/
TERMUX_PKG_DESCRIPTION="A small C library that is supposed to make it easy to run an HTTP server as part of another application"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.7"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libmicrohttpd/libmicrohttpd-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=827250db649546cdb04bea01f5f0560f0edffde9130e256387d1f977242eaf98
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libgnutls"
TERMUX_PKG_BREAKS="libmicrohttpd-dev"
TERMUX_PKG_REPLACES="libmicrohttpd-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-examples
--enable-curl
--enable-https
--enable-largefile
--enable-messages"
