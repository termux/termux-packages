TERMUX_PKG_HOMEPAGE=https://www.glfw.org/
TERMUX_PKG_DESCRIPTION="An Open Source, multi-platform library for OpenGL, OpenGL ES and Vulkan application development"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.8
TERMUX_PKG_SRCURL=https://github.com/glfw/glfw/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f30f42e05f11e5fc62483e513b0488d5bceeab7d9c5da0ffe2252ad81816c713
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
