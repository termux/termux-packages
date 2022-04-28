TERMUX_PKG_HOMEPAGE=https://www.glfw.org/
TERMUX_PKG_DESCRIPTION="An Open Source, multi-platform library for OpenGL, OpenGL ES and Vulkan application development"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/glfw/glfw/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fd21a5f65bcc0fc3c76e0f8865776e852de09ef6fbc3620e09ce96d2b2807e04
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="libxcursor, libxi, libxinerama, libxrandr, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DGLFW_BUILD_EXAMPLES=OFF
-DGLFW_BUILD_TESTS=OFF
-DGLFW_BUILD_DOCS=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
