TERMUX_PKG_HOMEPAGE=https://megatools.megous.com/
TERMUX_PKG_DESCRIPTION="Open-source command line tools and C library (libmega) for accessing Mega.co.nz cloud storage"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.0.20220519
TERMUX_PKG_SRCURL=https://megatools.megous.com/builds/megatools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b30b1d87d916570f7aa6d36777dd378e83215d75ea5a2c14106028b6bddc261b
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcurl, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsymlinks=true
"
