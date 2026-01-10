TERMUX_SUBPKG_INCLUDE="bin/luantiserver bin/minetestserver"
TERMUX_SUBPKG_DESCRIPTION="Headless server for the Luanti voxel game engine."
TERMUX_SUBPKG_DEPENDS="jsoncpp, libandroid-spawn, libc++, libcurl, libgmp, libiconv, luajit, libsqlite, luanti-common, zlib, zstd"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_BREAKS="luanti (<< 1:5.10.0-4)"
TERMUX_SUBPKG_REPLACES="luanti (<< 1:5.10.0-4)"
