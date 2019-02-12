TERMUX_PKG_HOMEPAGE=http://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=0.1.62
TERMUX_PKG_SHA256=1364e8e0dae5b03f96b3496348388508e4a93ab4f9cc0c06cca6a719e0c2ec36
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_DEPENDS="littlecms"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
