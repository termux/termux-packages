TERMUX_SUBPKG_INCLUDE="
lib/cmake/protobuf/protobuf-targets-release.cmake
lib/cmake/protobuf/protobuf-targets.cmake
"
TERMUX_SUBPKG_DESCRIPTION="CMake files for protobuf shared libraries"
TERMUX_SUBPKG_BREAKS="libprotobuf (<< 2:21.12)"
TERMUX_SUBPKG_REPLACES="libprotobuf (<< 2:21.12)"
TERMUX_SUBPKG_CONFLICTS="protobuf-static"
