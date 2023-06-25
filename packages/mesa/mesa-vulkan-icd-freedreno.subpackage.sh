TERMUX_SUBPKG_DESCRIPTION="Mesa's Freedreno Vulkan ICD"
TERMUX_SUBPKG_DEPENDS="vulkan-loader-generic"
TERMUX_SUBPKG_INCLUDE="
lib/libvulkan_freedreno.so
share/vulkan/icd.d/freedreno_icd.*.json
"
