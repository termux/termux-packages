TERMUX_PKG_HOMEPAGE=http://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_VERSION=0.1.54
TERMUX_PKG_SHA256=8f021557cde330a8e37e82d9c04aec4bf3e862d2eae52c9bd9ea4b4ea207ddd7
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
