TERMUX_PKG_HOMEPAGE="http://gegl.org/babl/"
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.30
TERMUX_PKG_SHA256=562ba7b1290d93d55029a92f700f2ec8602349b3acc7ae201188146b96e186be
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_FOLDERNAME=babl-BABL_${TERMUX_PKG_VERSION//./_}

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
