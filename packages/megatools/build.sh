TERMUX_PKG_HOMEPAGE=https://megatools.megous.com/
TERMUX_PKG_DESCRIPTION="Open-source command line tools and C library (libmega) for accessing Mega.co.nz cloud storage"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.1.20230212
TERMUX_PKG_SRCURL=https://megatools.megous.com/builds/megatools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ecfa2ee4b277c601ebae648287311030aa4ca73ea61ee730bc66bef24ef19a34
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcurl, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsymlinks=true
"
