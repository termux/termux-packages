TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-Loader
TERMUX_PKG_DESCRIPTION="Vulkan Loader"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.343"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-Loader/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42d78c1b7c70e52f12055a2bc91a33a4ca22f16dd6d76c7caee6ade096200002
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers (=${TERMUX_PKG_VERSION}), libx11, libxcb, libxrandr"
TERMUX_PKG_CONFLICTS="vulkan-loader-android"
TERMUX_PKG_PROVIDES="vulkan-loader-android"
TERMUX_PKG_RECOMMENDS="vulkan-icd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_REPOLOGY_METADATA_NAME=vulkan-loader
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DENABLE_WERROR=OFF
-DVULKAN_HEADERS_INSTALL_DIR=$TERMUX_PREFIX
-DPython3_EXECUTABLE=$(command -v python3)
--trace
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Wno-typedef-redefinition"
}

termux_step_post_make_install() {
	# Sanity check
	echo "INFO: ========== vulkan.pc =========="
	cat "$TERMUX_PREFIX/lib/pkgconfig/vulkan.pc"
	echo "INFO: ========== vulkan.pc =========="

	# Lots of apps will search libvulkan.so.1
	local e=0
	[ ! -e "$TERMUX_PREFIX"/lib/libvulkan.so ] && e=1
	[ ! -e "$TERMUX_PREFIX"/lib/libvulkan.so.1 ] && e=1
	if [[ "${e}" != 0 ]]; then
		termux_error_exit "
		Symlink check failed!
		$(file "$TERMUX_PREFIX"/lib/libvulkan.so)
		$(file "$TERMUX_PREFIX"/lib/libvulkan.so.1)
		"
	fi
}
