TERMUX_PKG_HOMEPAGE=https://handbrake.fr/
TERMUX_PKG_DESCRIPTION="A GPL-licensed, multiplatform, multithreaded video transcoder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/HandBrake/HandBrake/releases/download/${TERMUX_PKG_VERSION}/HandBrake-${TERMUX_PKG_VERSION}-source.tar.bz2
TERMUX_PKG_SHA256=94ccfe03db917a91650000c510f7fd53f844da19f19ad4b4be1b8f6bc31a8d4c
TERMUX_PKG_DEPENDS="ffmpeg, gdk-pixbuf, gst-plugins-base, gstreamer, gtk3, libass, libbluray, libcairo, libdvdnav, libdvdread, libiconv, libjansson, libjpeg-turbo, libtheora, libvorbis, libx264, libx265, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="liba52, libspeex, libzimg, svt-av1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--force
--prefix $TERMUX_PREFIX
--arch $TERMUX_ARCH
--disable-gtk-update-checks
--disable-numa
--disable-nvenc
"
# HandBrake binaries linked against fdk-aac are not redistributable.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-fdk-aac"

termux_step_pre_configure() {
	sed -i -E '/(\/contrib|contrib\/)/d' make/include/main.defs

	LDFLAGS+=" -liconv -lx265"
}

termux_step_configure() {
	$TERMUX_PKG_SRCDIR/configure $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
