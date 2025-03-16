TERMUX_PKG_HOMEPAGE="https://patriciogonzalezvivo.com/2015/glslViewer/"
TERMUX_PKG_DESCRIPTION="Console-based GLSL Sandbox for 2D/3D shaders"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.4"
TERMUX_PKG_SRCURL=git+https://github.com/patriciogonzalezvivo/glslViewer
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="ffmpeg, glfw, glu, libdrm, liblo, libxcb, mesa-dev, ncurses"
TERMUX_PKG_RECOMMENDS="xorg-server-xvfb"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CPPFLAGS+=" -Wno-implicit-function-declaration"
}
