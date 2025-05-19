TERMUX_SUBPKG_DESCRIPTION="Library for building Telegram clients, used by Telegram Desktop"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libc++, readline, openssl (>= 1.1.1), zlib"
TERMUX_SUBPKG_CONFLICTS="libtd, libtd-static"
TERMUX_SUBPKG_INCLUDE="
include/td/*
lib/cmake/tde2e/*
lib/pkgconfig/td*.pc
lib/libtd*.a
"
