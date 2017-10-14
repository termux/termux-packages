TERMUX_PKG_HOMEPAGE="http://gegl.org/babl/"
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.34
TERMUX_PKG_SHA256=d21ac99c97d9fb0bc61ecaf77a9ae1af95b75c83ccf066e223415818f9ce0b60
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
