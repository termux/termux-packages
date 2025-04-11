TERMUX_PKG_HOMEPAGE=https://www.glfw.org/
TERMUX_PKG_DESCRIPTION="An Open Source, multi-platform library for OpenGL, OpenGL ES and Vulkan application development"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4
TERMUX_PKG_SRCURL=https://github.com/glfw/glfw/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c038d34200234d071fae9345bc455e4a8f2f544ab60150765d7704e08f3dac01
TERMUX_PKG_DEPENDS="opengl"
TERMUX_PKG_BUILD_DEPENDS="libxcursor, libxi, libxinerama, libxrandr, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DGLFW_BUILD_EXAMPLES=OFF
-DGLFW_BUILD_TESTS=OFF
-DGLFW_BUILD_DOCS=OFF
-DGLFW_BUILD_WAYLAND=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
