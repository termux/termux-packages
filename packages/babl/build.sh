TERMUX_PKG_HOMEPAGE=http://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.58
TERMUX_PKG_SHA256=e51eeb6c9b8d1c25235bee5b2cb8fd3e6057752536751ebcf8c7db9b51305e03
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
