TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/Vulkan-ValidationLayers
TERMUX_PKG_DESCRIPTION="Vulkan Validation Layers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.334"
TERMUX_PKG_SRCURL=https://github.com/KhronosGroup/Vulkan-ValidationLayers/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a730695f9e0181febf66847181c14830d2f7d64cb32006fb9e273a1bb86b76c
TERMUX_PKG_DEPENDS="libc++, vulkan-loader"
TERMUX_PKG_BUILD_DEPENDS="libwayland, libx11, libxcb, libxrandr"
TERMUX_PKG_ANTI_BUILD_DEPENDS="vulkan-loader"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/KhronosGroup/Vulkan-ValidationLayers/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | grep -oP v${TERMUX_PKG_UPDATE_VERSION_REGEXP})
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | sort -V | tail -n1)
	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	# use upstream known_good.json to fetch and build deps
	"${TERMUX_PKG_SRCDIR}/scripts/update_deps.py" --generator Ninja

	find "$PWD" -name helper.cmake | sort | xargs -i bash -c "echo '===== {} =====' && cat {}"

	# prioritises build deps from source instead of system prefix
	# avoiding pollution from old dependencies
	local GLSLANG_INSTALL_DIR="${TERMUX_PKG_SRCDIR}/glslang/build/install"
	local GOOGLETEST_INSTALL_DIR="${TERMUX_PKG_SRCDIR}/googletest/build/install"
	local SPIRV_HEADERS_INSTALL_DIR="${TERMUX_PKG_SRCDIR}/SPIRV-Headers/build/install"
	local SPIRV_TOOLS_INSTALL_DIR="${TERMUX_PKG_SRCDIR}/SPIRV-Tools/build/install"
	local VULKAN_HEADERS_INSTALL_DIR="${TERMUX_PKG_SRCDIR}/Vulkan-Headers/build/install"
	local VULKAN_UTILITY_LIBRARIES_INSTALL_DIR="${TERMUX_PKG_SRCDIR}/Vulkan-Utility-Libraries/build/install"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DGLSLANG_INSTALL_DIR=${GLSLANG_INSTALL_DIR}
	-DGOOGLETEST_INSTALL_DIR=${GOOGLETEST_INSTALL_DIR}
	-DSPIRV_HEADERS_INSTALL_DIR=${SPIRV_HEADERS_INSTALL_DIR}
	-DSPIRV_TOOLS_INSTALL_DIR=${SPIRV_TOOLS_INSTALL_DIR}
	-DVULKAN_HEADERS_INSTALL_DIR=${VULKAN_HEADERS_INSTALL_DIR}
	-DVULKAN_UTILITY_LIBRARIES_INSTALL_DIR=${VULKAN_UTILITY_LIBRARIES_INSTALL_DIR}
	"

	CFLAGS="-I${GLSLANG_INSTALL_DIR}/include ${CFLAGS}"
	CFLAGS="-I${GOOGLETEST_INSTALL_DIR}/include ${CFLAGS}"
	CFLAGS="-I${SPIRV_HEADERS_INSTALL_DIR}/include ${CFLAGS}"
	CFLAGS="-I${SPIRV_TOOLS_INSTALL_DIR}/include ${CFLAGS}"
	CFLAGS="-I${VULKAN_HEADERS_INSTALL_DIR}/include ${CFLAGS}"
	CFLAGS="-I${VULKAN_UTILITY_LIBRARIES_INSTALL_DIR}/include ${CFLAGS}"
	CXXFLAGS="-I${GLSLANG_INSTALL_DIR}/include ${CXXFLAGS}"
	CXXFLAGS="-I${GOOGLETEST_INSTALL_DIR}/include ${CXXFLAGS}"
	CXXFLAGS="-I${SPIRV_HEADERS_INSTALL_DIR}/include ${CXXFLAGS}"
	CXXFLAGS="-I${SPIRV_TOOLS_INSTALL_DIR}/include ${CXXFLAGS}"
	CXXFLAGS="-I${VULKAN_HEADERS_INSTALL_DIR}/include ${CXXFLAGS}"
	CXXFLAGS="-I${VULKAN_UTILITY_LIBRARIES_INSTALL_DIR}/include ${CXXFLAGS}"
	LDFLAGS="-L${GLSLANG_INSTALL_DIR}/lib ${LDFLAGS}"
	LDFLAGS="-L${GOOGLETEST_INSTALL_DIR}/lib ${LDFLAGS}"
	LDFLAGS="-L${SPIRV_HEADERS_INSTALL_DIR}/lib ${LDFLAGS}"
	LDFLAGS="-L${SPIRV_TOOLS_INSTALL_DIR}/lib ${LDFLAGS}"
	LDFLAGS="-L${VULKAN_HEADERS_INSTALL_DIR}/lib ${LDFLAGS}"
	LDFLAGS="-L${VULKAN_UTILITY_LIBRARIES_INSTALL_DIR}/lib ${LDFLAGS}"
}
