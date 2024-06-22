TERMUX_PKG_HOMEPAGE=https://glew.sourceforge.net/
TERMUX_PKG_DESCRIPTION="The OpenGL Extension Wrangler Library"
TERMUX_PKG_LICENSE="BSD, GPL-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_REVISION=12
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/glew/glew-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=d4fc82893cfb00109578d0a1a2337fb8ca335b3ceccf97b97e5cc7f08e4353e1
TERMUX_PKG_DEPENDS="glu, libxi, libxmu"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LD=$CC
}
