TERMUX_PKG_HOMEPAGE=https://www.glfw.org/
TERMUX_PKG_DESCRIPTION="An Open Source, multi-platform library for OpenGL, OpenGL ES and Vulkan application development"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.1
TERMUX_PKG_SRCURL=https://github.com/glfw/glfw/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5234f4f29473e9a06bc7847d8371858dd135d38466eeeaa652fdc9f8f9ff0c20
TERMUX_PKG_DEPENDS="opengl"
TERMUX_PKG_AUTO_UPDATE=true
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
