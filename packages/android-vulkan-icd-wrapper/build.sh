TERMUX_PKG_HOMEPAGE="https://github.com/Pipetto-crypto/mesa"
TERMUX_PKG_DESCRIPTION="Android's Vulkan driver as a Vulkan ICD (AdrenoTools included)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE=docs/license.rst
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.1"
# adrenotools does not recieve futher updates currently
_LADRENOTOOLS_VERSION="1.0"
# it's dependency should not too
_LLNNSBYPASS_COMMIT="b10d48548d608dfca38ffc449d0350335b2f3737"
TERMUX_PKG_SRCURL="https://github.com/Pipetto-crypto/mesa/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8ebb38a36a8b9755105b66a9cf40bc2a7c517cd77e74afef8583f74ba5ee4a02
TERMUX_PKG_DEPENDS="libadrenotools, libandroid-shmem, libc++, libdrm, libwayland, libx11, libxcb, libxshmfence, vulkan-loader-generic, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libandroid-shmem-static, libwayland-protocols, libxrandr, xorgproto"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

TERMUX_PKG_API_LEVEL=28

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path ${TERMUX__PREFIX}
-Dgbm=disabled
-Dopengl=false
-Dllvm=disabled
-Dshared-llvm=disabled
-Dplatforms=wayland,x11
-Dgallium-drivers=
-Dxmlconfig=disabled
-Dvulkan-drivers=wrapper
-Dcpp_rtti=false
"

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -rf subprojects
}

termux_step_pre_configure() {
	termux_setup_cmake

	# error: 'AHardwareBuffer_release' is unavailable: introduced in Android 26 android
	if [[ "${TERMUX_ON_DEVICE_BUILD}" = true ]]; then
		CFLAGS+=" --target=${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL}"
	fi

	LDFLAGS+=" -landroid-shmem"
}
