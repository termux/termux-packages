TERMUX_PKG_HOMEPAGE=http://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=0.1.68
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=788f60c6ae9a78c9ed7b6a0f2a1e2c493d81a5b1e5f3c795447b01824331637e
TERMUX_PKG_DEPENDS="littlecms"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
