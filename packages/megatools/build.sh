TERMUX_PKG_HOMEPAGE=https://megatools.megous.com/
TERMUX_PKG_DESCRIPTION="Open-source command line tools and C library (libmega) for accessing Mega.co.nz cloud storage"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.10.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://megatools.megous.com/builds/megatools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=179e84c68e24696c171238a72bcfe5e28198e4c4e9f9043704f36e5c0b17c38a
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcurl, libgmp, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-fuse --enable-docs-build"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    mkdir -p m4
    autoreconf -v --install

    sed -i -e 's/-V -qversion//' configure
    sed -i -e 's/GOBJECT_INTROSPECTION_CHECK/#GOBJECT_INTROSPECTION_CHECK/' configure
}
