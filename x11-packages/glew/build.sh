TERMUX_PKG_HOMEPAGE=http://glew.sourceforge.net/
TERMUX_PKG_DESCRIPTION="The OpenGL Extension Wrangler Library"
TERMUX_PKG_LICENSE="BSD, GPL-2.0, MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/glew/glew-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95
TERMUX_PKG_DEPENDS="glu, libxi, libxmu"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LD=$CC
}
