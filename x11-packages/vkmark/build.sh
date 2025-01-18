TERMUX_PKG_HOMEPAGE=https://github.com/vkmark/vkmark
TERMUX_PKG_DESCRIPTION="Vulkan benchmark"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING-LGPL2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ab6e6f34077722d5ae33f6bd40b18ef9c0e99a15
_COMMIT_DATE=2023.04.12
TERMUX_PKG_VERSION="${_COMMIT_DATE}-r139.${_COMMIT:0:7}"
TERMUX_PKG_SRCURL=git+https://github.com/vkmark/vkmark
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_SHA256=2fde566a542fddc5c74a62c40dcb2d62e1151c7fbdc395adb1dc21857defa09d
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="assimp, libc++, libxcb, vulkan-loader-generic, xcb-util-wm"
TERMUX_PKG_BUILD_DEPENDS="glm, vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dxcb=true -Dkms=false"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
	local commit_date="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$commit_date" != "$_COMMIT_DATE" ]; then
		echo -n "ERROR: The specified commit date \"$_COMMIT_DATE\""
		echo " is different from what is expected to be: \"$commit_date\""
		return 1
	fi

	local version="$(printf "${_COMMIT_DATE}-r%d.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)")"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}
