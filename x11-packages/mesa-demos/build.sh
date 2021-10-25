TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="OpenGL demonstration and test programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=8.4.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://archive.mesa3d.org//demos/mesa-demos-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=01e99c94a0184e63e796728af89bfac559795fb2a0d6f506fa900455ca5fff7d
TERMUX_PKG_DEPENDS="libx11, mesa, libdrm, freetype, libxext, glew, freeglut"

termux_step_pre_configure() {
	sed -i '/tests /d' src/Makefile.am
	sed -i 's/ -lpthread//' src/xdemos/Makefile.am
	autoreconf -fi
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/mesa-demos $TERMUX_PKG_BUILDER_DIR/LICENSE
}
