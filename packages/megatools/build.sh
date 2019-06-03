TERMUX_PKG_HOMEPAGE=https://github.com/megous/megatools
TERMUX_PKG_DESCRIPTION="Open-source command line tools and C library (libmega) for accessing Mega.co.nz cloud storage"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.10.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=48468536492bfecd8b10a42e7608129eba9922e03cbce0a11dd9e338e2a0632d
TERMUX_PKG_SRCURL=https://github.com/megous/megatools/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="glib, libandroid-support, libcurl, libgmp, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-fuse --enable-docs-build"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    mkdir -p m4
    autoreconf -v --install

    sed -i -e 's/-V -qversion//' configure
    sed -i -e 's/GOBJECT_INTROSPECTION_CHECK/#GOBJECT_INTROSPECTION_CHECK/' configure
}
