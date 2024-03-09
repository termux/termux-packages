TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/glslang
TERMUX_PKG_DESCRIPTION="OpenGL and OpenGL ES shader front end and validator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="14.1.0"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/glslang/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b5e4c36d60eda7613f36cfee3489c6f507156829c707e1ecd7f48ca45b435322
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="spirv-tools"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DALLOW_EXTERNAL_SPIRV_TOOLS=ON
"

termux_step_post_make_install() {
	# build system only build static or shared at a time
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DBUILD_SHARED_LIBS=ON
	"
	termux_step_configure
	termux_step_make
	termux_step_make_install
}
