TERMUX_PKG_HOMEPAGE="http://gmic.eu"
TERMUX_PKG_DESCRIPTION="imageman"
TERMUX_PKG_VERSION=0.3.6
TERMUX_PKG_SRCURL=https://git.gnome.org/browse/gegl/snapshot/GEGL_0_3_14.tar.xz
TERMUX_PKG_FOLDERNAME=GEGL_0_3_14
TERMUX_PKG_SHA256=941b8d48a0abd4299717be9ae92b084d478775503eb0ef79ca9d4bfffbd2623b
TERMUX_PKG_DEPENDS="graphviz, babl, json-glib, libpng, libffi"
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_pre_configure() {
	export GRAPHVIZ=yes
	LDFLAGS+=" -landroid-support"
	./autogen.sh
}
