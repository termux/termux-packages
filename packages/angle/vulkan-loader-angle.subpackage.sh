TERMUX_SUBPKG_DESCRIPTION="The vulkan loader targeting X11/Wayland provided by ANGLE"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no
TERMUX_SUBPKG_DEPENDS="swiftshader"
TERMUX_SUBPKG_CONFLICTS="vulkan-loader-android"
TERMUX_SUBPKG_REPLACES="vulkan-loader-android"
TERMUX_SUBPKG_INCLUDE="
lib/libvulkan.so
lib/libvulkan.so.1
"
