TERMUX_PKG_HOMEPAGE=http://www.brain-dump.org/projects/abduco/
TERMUX_PKG_DESCRIPTION="Clean and simple terminal session manager"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_VERSION=0.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.brain-dump.org/projects/abduco/abduco-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c90909e13fa95770b5afc3b59f311b3d3d2fdfae23f9569fa4f96a3e192a35f4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="dvtm"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
