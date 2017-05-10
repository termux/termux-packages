TERMUX_PKG_HOMEPAGE="gegl.org"
TERMUX_PKG_DESCRIPTION="data flow based image processing framework"
TERMUX_PKG_VERSION=0.3.14
TERMUX_PKG_SRCURL=https://git.gnome.org/browse/gegl/snapshot/GEGL_0_3_14.tar.xz
TERMUX_PKG_FOLDERNAME=GEGL_0_3_14
TERMUX_PKG_SHA256=941b8d48a0abd4299717be9ae92b084d478775503eb0ef79ca9d4bfffbd2623b
TERMUX_PKG_DEPENDS="ffmpeg,  babl, json-glib, libpng, libffi"
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_pre_configure() {
	LDFLAGS+=" -landroid-support"
        NOCONFIGURE=1 ./autogen.sh
}
