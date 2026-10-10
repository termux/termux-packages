TERMUX_SUBPKG_DESCRIPTION="Mesa's VirtIO Vulkan ICD"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, zlib, zstd, libdrm, libxcb, libx11, libxshmfence, libwayland"
TERMUX_SUBPKG_INCLUDE="
lib/libvulkan_virtio.so
share/vulkan/icd.d/virtio_icd.*.json
"
