TERMUX_SUBPKG_DESCRIPTION="Mesa's Freedreno Vulkan ICD"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libc++, libdrm, libx11, libxcb, libxshmfence, libwayland, vulkan-loader-generic, zlib, zstd"
TERMUX_SUBPKG_EXCLUDED_ARCHES="i686, x86_64"
TERMUX_SUBPKG_REPLACES="mesa-vulkan-icd-freedreno-dri3"
TERMUX_SUBPKG_BREAKS="mesa-vulkan-icd-freedreno-dri3"
TERMUX_SUBPKG_PROVIDES="mesa-vulkan-icd-freedreno-dri3"
TERMUX_SUBPKG_INCLUDE="
lib/libvulkan_freedreno.so
share/vulkan/icd.d/freedreno_icd.*.json
"
