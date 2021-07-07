TERMUX_PKG_HOMEPAGE=https://www.spice-space.org/
TERMUX_PKG_DESCRIPTION="Implements the server side of the SPICE protocol"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14.91
TERMUX_PKG_SRCURL=https://www.spice-space.org/download/releases/spice-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d29acdfe56a09a4f68ddb11e1be27029d478dd863c80245a02e2eaae54afa10f
TERMUX_PKG_DEPENDS="glib, libjpeg-turbo, gstreamer, gst-plugins-base, libsasl, libspice-protocol, liborc, openssl, libopus, libpixman, liblz4, zlib, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-manual=no
--disable-tests
"
termux_step_post_make_install() {
        ln -sfr "${TERMUX_PREFIX}"/lib/libspice-server.so \
                "${TERMUX_PREFIX}"/lib/libspice-server.so.1
}
