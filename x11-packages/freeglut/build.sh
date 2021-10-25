TERMUX_PKG_HOMEPAGE=http://freeglut.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Provides functionality for small OpenGL programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.1
TERMUX_PKG_REVISION=15
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/freeglut/freeglut-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68
TERMUX_PKG_DEPENDS="glu, libxi, libxrandr, mesa"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
}
