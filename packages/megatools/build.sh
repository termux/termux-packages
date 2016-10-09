TERMUX_PKG_HOMEPAGE=https://github.com/megous/megatools
TERMUX_PKG_DESCRIPTION="Open-source command line tools and C library (libmega) for accessing Mega.co.nz cloud storage"
TERMUX_PKG_VERSION=1.9.97
TERMUX_PKG_SRCURL=https://github.com/megous/megatools/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_FOLDERNAME=megatools-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcurl, libgmp, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-fuse --disable-glibtest"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    ./autogen.sh
}