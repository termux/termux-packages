TERMUX_PKG_HOMEPAGE=https://handbrake.fr/
TERMUX_PKG_DESCRIPTION="A GPL-licensed, multiplatform, multithreaded video transcoder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/HandBrake/HandBrake/releases/download/${TERMUX_PKG_VERSION}/HandBrake-${TERMUX_PKG_VERSION}-source.tar.bz2
TERMUX_PKG_SHA256=c65e1cc4f8cfc36c24107b92c28d60e71ef185ec983e9a5841facffafea5f8db
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, gdk-pixbuf, gst-plugins-base, gstreamer, gtk4, libass, libbluray, libcairo, libdav1d, libdvdnav, libdvdread, libiconv, libjansson, libjpeg-turbo, libtheora, libvorbis, libvpx, libx264, libx265, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="liba52, libspeex, libzimg, svt-av1"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--force
--prefix $TERMUX_PREFIX
--arch $TERMUX_ARCH
--disable-numa
--disable-nvenc
"
# HandBrake binaries linked against fdk-aac are not redistributable.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-fdk-aac"

termux_step_pre_configure() {
	# handbrake configure attempts to detect meson and cmake,
	# then during the build it runs more nested configures using
	# meson and cmake build files, then if the GUI is enabled
	# it attempts to detect and run glib-compile-resources
	termux_setup_meson
	termux_setup_cmake
	termux_setup_glib_cross_pkg_config_wrapper

	sed -i "s|'meson'|'$TERMUX_MESON'|g" make/configure.py
	# override GTK.CONFIGURE.cross at the end of the gtk/module.defs file
	# because the existing instance of --cross-file in the middle of the file
	# is inside a condition that fails to activate when $TERMUX_ARCH is x86_64
	echo >> gtk/module.defs
	echo "GTK.CONFIGURE.cross = --cross-file=$TERMUX_MESON_CROSSFILE" >> gtk/module.defs

	LDFLAGS+=" -liconv -lx265"
}

termux_step_configure() {
	$TERMUX_PKG_SRCDIR/configure $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
