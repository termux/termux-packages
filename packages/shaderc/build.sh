TERMUX_PKG_HOMEPAGE=https://github.com/google/shaderc
TERMUX_PKG_DESCRIPTION="Collection of tools, libraries, and tests for Vulkan shader compilation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/google/shaderc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a89fb6612ace8954470aae004623374a8fc8b7a34a4277bee5527173b064faf
TERMUX_PKG_DEPENDS="glslang, spirv-tools, libc++"
TERMUX_PKG_BUILD_DEPENDS="spirv-headers"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DSHADERC_SKIP_TESTS=ON
-Dglslang_SOURCE_DIR=$TERMUX_PREFIX/include/glslang
"

termux_step_pre_configure() {
	# based on Arch Linux:
	# https://gitlab.archlinux.org/archlinux/packaging/packages/shaderc/-/blob/3ed2bcb6358e964d75044f075a04cb0cd8bd4fa8/README.md
	# de-vendor libs and disable git versioning
	local _SPIRV_TOOLS_BUILD_SH="$TERMUX_SCRIPTDIR/packages/spirv-tools/build.sh"
	local _GLSLANG_BUILD_SH="$TERMUX_SCRIPTDIR/packages/glslang/build.sh"
	local _SPIRV_TOOLS_VERSION=$(bash -c ". $_SPIRV_TOOLS_BUILD_SH; echo \${TERMUX_PKG_VERSION#*:}")
	local _GLSLANG_VERSION=$(bash -c ". $_GLSLANG_BUILD_SH; echo \${TERMUX_PKG_VERSION#*:}")

	sed '/examples/d;/third_party/d' -i "$TERMUX_PKG_SRCDIR/CMakeLists.txt"
	sed '/build-version/d' -i "$TERMUX_PKG_SRCDIR/glslc/CMakeLists.txt"
	cat <<- EOF > "$TERMUX_PKG_SRCDIR/glslc/src/build-version.inc"
		"${TERMUX_PKG_VERSION}\\n"
		"${_SPIRV_TOOLS_VERSION}\\n"
		"${_GLSLANG_VERSION}\\n"
	EOF
}
