TERMUX_PKG_HOMEPAGE=https://xff.cz/megatools/
TERMUX_PKG_DESCRIPTION="Open-source command line tools and C library (libmega) for accessing Mega.co.nz cloud storage"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.2.20261116
TERMUX_PKG_SRCURL=https://xff.cz/megatools/builds/megatools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2c8cfbb41eabf1ffac92f08f5b3aecb361bcfb9c02ac258769fb5e3ba2f15b84
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcurl, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsymlinks=true
"
