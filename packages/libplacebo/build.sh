TERMUX_PKG_HOMEPAGE=http://libplacebo.org/
TERMUX_PKG_DESCRIPTION="Reusable library for GPU-accelerated video/image rendering"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.360.0"
TERMUX_PKG_SRCURL="https://code.videolan.org/videolan/libplacebo/-/archive/v${TERMUX_PKG_VERSION}/libplacebo-v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7f4e182526b738805ff793717c67a256bc3f6bc10025017f0b10193f2c79abb9
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

termux_step_post_get_source() {
	local _FASTFLOAT_VERSION="8.2.3"
	local _FASTFLOAT_URL="https://github.com/fastfloat/fast_float/releases/download/v$_FASTFLOAT_VERSION/fast_float.h"
	local _FASTFLOAT_SHA256=9a23f7f8b0a953a50ce5dac10f7e0684f29230b11d71e2ee5bd89e084cebba06
	local _FASTFLOAT_CACHE="$TERMUX_PKG_CACHEDIR/fast_float.$_FASTFLOAT_VERSION.h"
	local _FASTFLOAT_DEST="$TERMUX_PKG_SRCDIR/src/include/fast_float/fast_float.h"
	termux_download "$_FASTFLOAT_URL" "$_FASTFLOAT_CACHE" "$_FASTFLOAT_SHA256"
	install -D "$_FASTFLOAT_CACHE" "$_FASTFLOAT_DEST"
}
