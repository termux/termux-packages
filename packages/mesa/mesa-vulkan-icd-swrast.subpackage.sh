TERMUX_SUBPKG_DESCRIPTION="Mesa's Swrast Vulkan ICD"
TERMUX_SUBPKG_DEPENDS="vulkan-loader-generic"
TERMUX_SUBPKG_INCLUDE="
lib/libvulkan_lvp.so
share/vulkan/icd.d/lvp_icd.*.json
"
