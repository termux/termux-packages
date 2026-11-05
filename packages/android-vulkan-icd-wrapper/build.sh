TERMUX_PKG_HOMEPAGE="https://github.com/Pipetto-crypto/mesa"
TERMUX_PKG_DESCRIPTION="Android's Vulkan driver as a Vulkan ICD (AdrenoTools included)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE=docs/license.rst
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.2"
TERMUX_PKG_SRCURL="https://github.com/Pipetto-crypto/mesa/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3e00a79184dfb1d3a8e35941a8a9efa35e0f77cdd5b066c168e067b14e425a70
TERMUX_PKG_DEPENDS="libadrenotools, libandroid-shmem, libc++, libdrm, libwayland, libx11, libxcb, libxshmfence, vulkan-loader-generic"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols"

TERMUX_PKG_API_LEVEL=28


TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path ${TERMUX__PREFIX}
-Dgbm=disabled
-Dopengl=false
-Dllvm=disabled
-Dplatforms=wayland,x11
-Dgallium-drivers=
-Dvulkan-drivers=wrapper
-Dxmlconfig=disabled
"

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -rf subprojects
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_wayland_cross_pkg_config_wrapper

	# error: 'AHardwareBuffer_release' is unavailable: introduced in Android 26 android
	if [[ "${TERMUX_ON_DEVICE_BUILD}" = true ]]; then
		CFLAGS+=" --target=${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL}"
	fi

	LDFLAGS+=" -landroid-shmem"
}
