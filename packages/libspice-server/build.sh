TERMUX_PKG_HOMEPAGE=https://www.spice-space.org/
TERMUX_PKG_DESCRIPTION="Implements the server side of the SPICE protocol"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.2"
TERMUX_PKG_SRCURL=https://www.spice-space.org/download/releases/spice-server/spice-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6d9eb6117f03917471c4bc10004abecff48a79fb85eb85a1c45f023377015b81
TERMUX_PKG_DEPENDS="glib, gst-plugins-base, gstreamer, libc++, libiconv, libjpeg-turbo, liblz4, libopus, liborc, libpixman, libsasl, libspice-protocol, openssl, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-manual=no
--disable-tests
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

termux_step_post_make_install() {
	ln -sf libspice-server.so "${TERMUX_PREFIX}"/lib/libspice-server.so.1
}
