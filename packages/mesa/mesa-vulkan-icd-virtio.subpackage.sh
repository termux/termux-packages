TERMUX_SUBPKG_DESCRIPTION="Mesa's  Vulkan pipe clent that connect to a server"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libbthread, libc++, libdrm, libx11, libxcb, libxshmfence, libwayland, ncurses, vulkan-loader-generic, zlib, zstd"
TERMUX_SUBPKG_INCLUDE="
lib/libvulkan_virtio.so
share/vulkan/icd.d/virtio_icd.*.json
"
