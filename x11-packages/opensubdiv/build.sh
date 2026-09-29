TERMUX_PKG_HOMEPAGE=https://graphics.pixar.com/opensubdiv/docs/intro.html
TERMUX_PKG_DESCRIPTION="A set of open source libraries that implement high performance subdivision surface (subdiv) evaluation"
# License: Modified Apache 2.0 License
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, NOTICE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.7.0"
TERMUX_PKG_SRCURL=https://github.com/PixarAnimationStudios/OpenSubdiv/archive/refs/tags/v${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=f843eb49daf20264007d807cbc64516a1fed9cdb1149aaf84ff47691d97491f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+_\d+_\d+(?!RC)"
TERMUX_PKG_DEPENDS="libc++, libtbb, opengl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DNO_EXAMPLES=ON
-DNO_TUTORIALS=ON
-DNO_PTEX=ON
-DNO_DOC=ON
-DNO_CUDA=ON
-DNO_OPENCL=ON
-DNO_TESTS=ON
-DNO_GLFW=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
