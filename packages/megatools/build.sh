TERMUX_PKG_HOMEPAGE=https://xff.cz/megatools/
TERMUX_PKG_DESCRIPTION="Open-source command line tools and C library (libmega) for accessing Mega.co.nz cloud storage"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.5.20250706
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://xff.cz/megatools/builds/megatools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=51f78a03748a64b1066ce28a2ca75d98dbef5f00fe9789dc894827f9a913b362
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcurl, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsymlinks=true
"
