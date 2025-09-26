TERMUX_PKG_HOMEPAGE=https://github.com/google/shaderc
TERMUX_PKG_DESCRIPTION="Collection of tools, libraries, and tests for Vulkan shader compilation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.4"
TERMUX_PKG_SRCURL=https://github.com/google/shaderc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a89fb6612ace8954470aae004623374a8fc8b7a34a4277bee5527173b064faf
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_CONFLICTS="glslang, spirv-tools"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSHADERC_SKIP_TESTS=ON
"

termux_step_post_get_source() {
	./utils/git-sync-deps
}
