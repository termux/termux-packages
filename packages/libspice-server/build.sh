TERMUX_PKG_HOMEPAGE=https://www.spice-space.org/
TERMUX_PKG_DESCRIPTION="Remote access to virtual machines, server part"
TERMUX_PKG_VERSION=0.12.8
TERMUX_PKG_SRCURL=https://www.spice-space.org/download/releases/spice-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f901a5c5873d61acac84642f9eea5c4d6386fc3e525c2b68792322794e1c407d
TERMUX_PKG_DEPENDS="libspice-protocol, libpixman, libsasl, glib, openssl, libjpeg-turbo"
# Unfortunately we have to disable CEL, OpenGL, smartcard and LZ4 for now
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-celt051 --disable-opengl --disable-smartcard --disable-lz4 --enable-manual --enable-sasl"
