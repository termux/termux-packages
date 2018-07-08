TERMUX_PKG_HOMEPAGE=http://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.52
TERMUX_PKG_SHA256=c9baa5af767785e535be22f4c693fbcb9f9efef61906d9ab2363b8c9b75b7a59
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
