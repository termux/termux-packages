TERMUX_PKG_HOMEPAGE=https://handbrake.fr/
TERMUX_PKG_DESCRIPTION="A GPL-licensed, multiplatform, multithreaded video transcoder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/HandBrake/HandBrake/releases/download/${TERMUX_PKG_VERSION}/HandBrake-${TERMUX_PKG_VERSION}-source.tar.bz2
TERMUX_PKG_SHA256=7f23c76038b7bf329089d0eb33c14898400fcc0426e310e87dc11e538c103cda
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

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
}

termux_step_configure() {
	$TERMUX_PKG_SRCDIR/configure $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
