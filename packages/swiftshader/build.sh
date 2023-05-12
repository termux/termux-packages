TERMUX_PKG_HOMEPAGE=https://swiftshader.googlesource.com/SwiftShader
TERMUX_PKG_DESCRIPTION="A high-performance CPU-based implementation of the Vulkan graphics API"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_CHROMIUM_VERSION=110.0.5481.177
TERMUX_PKG_VERSION=$_CHROMIUM_VERSION
TERMUX_PKG_SRCURL=https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$_CHROMIUM_VERSION.tar.xz
TERMUX_PKG_SHA256=7b2f454d1195270a39f94a9ff6d8d68126be315e0da4e31c20f4ba9183a1c9b7
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, vulkan-loader-generic"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSWIFTSHADER_BUILD_TESTS=FALSE
-DSWIFTSHADER_WARNINGS_AS_ERRORS=FALSE
-DSPIRV_HEADERS_SKIP_INSTALL=ON
-DSKIP_SPIRV_TOOLS_INSTALL=OFF
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/third_party/swiftshader
}

termux_step_make_install() {
	cp libvk_swiftshader.so $TERMUX_PREFIX/lib

	mkdir -p $TERMUX_PREFIX/share/vulkan/icd.d/
	python $TERMUX_PKG_SRCDIR/src/Vulkan/write_icd_json.py \
		--input $TERMUX_PKG_SRCDIR/src/Vulkan/vk_swiftshader_icd.json.tmpl \
		--output $TERMUX_PREFIX/share/vulkan/icd.d/vk_swiftshader_icd.json \
		--library_path $TERMUX_PREFIX/lib/libvk_swiftshader.so
}
