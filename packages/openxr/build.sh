TERMUX_PKG_HOMEPAGE=https://www.khronos.org/openxr/
TERMUX_PKG_DESCRIPTION="Open standard that provides a common set of APIs for developing XR applications"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.49"
TERMUX_PKG_SRCURL="https://github.com/KhronosGroup/OpenXR-SDK-Source/releases/download/release-$TERMUX_PKG_VERSION/OpenXR-SDK-Source-release-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=207452a51ec9d730742c385adb5af21fb266fa7be8090b251f76c0bd2b433c61
# configuration error if jsoncpp and jsoncpp-static are not both installed simultaneously
TERMUX_PKG_DEPENDS="jsoncpp, libc++, libx11, vulkan-icd, libxrandr, libxxf86vm, opengl"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_BUILD_DEPENDS="jsoncpp-static, vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DPRESENTATION_BACKEND=xlib
-DDYNAMIC_LOADER=ON
"

termux_step_pre_configure() {
	# This software has a SurfaceFlinger(ANativeWindow[For building an APK]) configuration
	# aggressively connected to its __ANDROID__ blocks, so use the same 'treat Android as Linux'
	# strategy here that is used in the sdl2 package.
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)\(__[^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)__$/\1_NO_TERMUX__/g'
}
