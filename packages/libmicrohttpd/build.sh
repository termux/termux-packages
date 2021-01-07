TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/libmicrohttpd/
TERMUX_PKG_DESCRIPTION="A small C library that is supposed to make it easy to run an HTTP server as part of another application"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.72
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0ae825f8e0d7f41201fd44a0df1cf454c1cb0bc50fe9d59c26552260264c2ff8
TERMUX_PKG_DEPENDS="libgnutls"
TERMUX_PKG_BREAKS="libmicrohttpd-dev"
TERMUX_PKG_REPLACES="libmicrohttpd-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-examples
--enable-curl
--enable-https
--enable-largefile
--enable-messages"
