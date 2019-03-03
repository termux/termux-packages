TERMUX_PKG_HOMEPAGE=http://www.ece.uvic.ca/~frodo/jasper/
TERMUX_PKG_DESCRIPTION="Library for manipulating JPEG-2000 files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.0.14
TERMUX_PKG_SHA256=85266eea728f8b14365db9eaf1edc7be4c348704e562bb05095b9a077cf1a97b
TERMUX_PKG_SRCURL=https://github.com/mdadams/jasper/archive/version-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-H$TERMUX_PKG_SRCDIR
-B$TERMUX_PKG_BUILDDIR
"
termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
