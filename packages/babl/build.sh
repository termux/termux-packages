TERMUX_PKG_HOMEPAGE="http://gegl.org/babl/"
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.28
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_FOLDERNAME=babl-BABL_${TERMUX_PKG_VERSION//./_}
TERMUX_PKG_SHA256=f0029106c36bd1b1ec66bc761712aa8db60cd047dea0b02b30ad42003e465b39

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
