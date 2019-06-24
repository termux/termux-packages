TERMUX_PKG_HOMEPAGE=http://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=0.1.66
TERMUX_PKG_SHA256=7d4096a9211b62fe622575746ef80456749f9baced7c197dcac602d0e8f0032b
TERMUX_PKG_SRCURL=https://github.com/GNOME/babl/archive/BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_DEPENDS="littlecms"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
