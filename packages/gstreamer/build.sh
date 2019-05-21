TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Open source multimedia framework"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0e8e2f7118be437cba879353970cf83c2acced825ecb9275ba05d9186ef07c00
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_DEVPACKAGE_DEPENDS="glib-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-check
--disable-tests
--disable-examples
--disable-benchmarks
--with-unwind=no
--with-dw=no
GLIB_GENMARSHAL=/usr/bin/glib-genmarshal
GLIB_MKENUMS=/usr/bin/glib-mkenums
"
