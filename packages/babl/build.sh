TERMUX_PKG_HOMEPAGE="http://gegl.org/babl/"
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.42
TERMUX_PKG_SHA256=01efef810ce6e3c8cc83171b31867f269c6cd4244bd2780635e8c6269e6233f7
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
