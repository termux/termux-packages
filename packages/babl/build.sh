TERMUX_PKG_HOMEPAGE=http://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=0.1.64
TERMUX_PKG_SHA256=470b80cfe7eb79fcc6d1fc8dca19f9dc3d07dc663fc5fffb7ca003df5e0149d6
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_DEPENDS="littlecms"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
