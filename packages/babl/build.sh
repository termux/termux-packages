TERMUX_PKG_HOMEPAGE="http://gegl.org/babl/"
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.26
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_FOLDERNAME=babl-BABL_${TERMUX_PKG_VERSION//./_}
TERMUX_PKG_SHA256=8cc78dd4d9948383e6c954bc5cca55b362d4de7a1df81a7b80777f59965e850f

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
