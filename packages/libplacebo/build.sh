TERMUX_PKG_HOMEPAGE=http://libplacebo.org/
TERMUX_PKG_DESCRIPTION="Reusable library for GPU-accelerated video/image rendering"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.351.0"
_FASTFLOAT_VERSION="8.1.0"
_FASTFLOAT_URL="https://github.com/fastfloat/fast_float/releases/download/v$_FASTFLOAT_VERSION/fast_float.h"
_FASTFLOAT_SHA256=bfa4f3e3ee72e10d833533ffffdbcff19e9f49e89ae98d95c9b03e1610253169
TERMUX_PKG_SRCURL="https://github.com/haasn/libplacebo/archive/refs/tags/v$TERMUX_PKG_VERSION/libplacebo-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=716954501d9b76e6906fddda66febc5886493d0673dd265ec1e6e52f4e5cd7c6
TERMUX_PKG_DEPENDS="littlecms, glslang, python, vulkan-icd"
TERMUX_PKG_BUILD_DEPENDS="libglvnd-dev, vulkan-headers"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="glad2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dvulkan=enabled
-Dglslang=enabled
-Dlcms=enabled
-Dlibdovi=disabled
-Dshaderc=disabled
-Dd3d11=disabled
-Dtests=false
"

termux_step_pre_configure() {
	local _FASTFLOAT_CACHED="$TERMUX_PKG_CACHEDIR/fast_float.h.$_FASTFLOAT_VERSION"
	local _FASTFLOAT_DEST="$TERMUX_PKG_SRCDIR/src/include/fast_float/fast_float.h"
	termux_download "$_FASTFLOAT_URL" "$_FASTFLOAT_CACHED" "$_FASTFLOAT_SHA256"
	install -D "$_FASTFLOAT_CACHED" "$_FASTFLOAT_DEST"
}
