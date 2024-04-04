TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-ExtensionLayer
TERMUX_PKG_DESCRIPTION="Vulkan Tools and Utilities"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="xMeM <haooy@outlook.com>"
_COMMIT=9277c26d35dba4d63b14af626aa6db2d1cf96536
TERMUX_PKG_VERSION="0.0.1-r106.${_COMMIT:0:7}"
TERMUX_PKG_SRCURL=git+https://github.com/xMeM/vulkan-wsi-layer
TERMUX_PKG_SHA256="c27319b72eb98aad5edaebaad8511cdc9b7dc3ee8cd89a3e2ce8e086ee2b625a"
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, vulkan-loader-generic"
TERMUX_PKG_RECOMMENDS="vulkan-loader-generic"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DVULKAN_HEADERS_INSTALL_DIR=$TERMUX_PREFIX
"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(printf "0.0.1-r%d.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)")"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
    echo "$s"
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}
