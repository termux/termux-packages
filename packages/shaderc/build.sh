TERMUX_PKG_HOMEPAGE=https://github.com/google/shaderc
TERMUX_PKG_DESCRIPTION="Collection of tools, libraries, and tests for Vulkan shader compilation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2023.7"
TERMUX_PKG_SRCURL=https://github.com/google/shaderc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=681e1340726a0bf46bea7e31f10cbfe78e01e4446a35d90fedc2b78d400fcdeb
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
