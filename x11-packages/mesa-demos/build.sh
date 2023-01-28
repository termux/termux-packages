TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="OpenGL demonstration and test programs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=8.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/demos/${TERMUX_PKG_VERSION}/mesa-demos-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cea2df0a80f09a30f635c4eb1a672bf90c5ddee0b8e77f4d70041668ef71aac1
TERMUX_PKG_DEPENDS="freeglut, glu, libx11, libxext, opengl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibdrm=disabled
-Dwayland=disabled
"

termux_step_pre_configure() {
	rm -f configure
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}
