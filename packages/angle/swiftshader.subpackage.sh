TERMUX_SUBPKG_DESCRIPTION="A high-performance CPU-based implementation of the Vulkan graphics API"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libc++"
TERMUX_SUBPKG_INCLUDE="
lib/angle/libvulkan.so.1
lib/angle/libvk_swiftshader.so
lib/angle/vk_swiftshader_icd.json
share/vulkan/icd.d/vk_swiftshader_icd.json
"
