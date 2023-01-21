TERMUX_SUBPKG_DESCRIPTION="GLVND's OpenGL headers"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_BREAKS="mesa (<< 22.3.3-2), mesa-dev (<< 22.3.3-2), ndk-sysroot (<< 25b-3)"
TERMUX_SUBPKG_REPLACES="mesa (<< 22.3.3-2), mesa-dev (<< 22.3.3-2), ndk-sysroot (<< 25b-3)"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_INCLUDE="
include/
"
