TERMUX_PKG_HOMEPAGE=https://glew.sourceforge.net/
TERMUX_PKG_DESCRIPTION="The OpenGL Extension Wrangler Library"
TERMUX_PKG_LICENSE="BSD, GPL-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/nigels-com/glew/releases/download/glew-${TERMUX_PKG_VERSION}/glew-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=b64790f94b926acd7e8f84c5d6000a86cb43967bd1e688b03089079799c9e889
TERMUX_PKG_DEPENDS="glu, libxi, libxmu"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="SYSTEM=linux-egl"

termux_step_pre_configure() {
	LD=$CC
}
