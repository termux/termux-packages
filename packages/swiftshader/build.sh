TERMUX_PKG_HOMEPAGE=https://swiftshader.googlesource.com/SwiftShader
TERMUX_PKG_DESCRIPTION="A high-performance CPU-based implementation of the Vulkan graphics API"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT_DATE=2024.05.08
_COMMIT_HASH=da334852e70510d259bfa8cbaa7c5412966b2f41
TERMUX_PKG_VERSION=$_COMMIT_DATE
TERMUX_PKG_SRCURL=https://github.com/google/swiftshader/archive/$_COMMIT_HASH.tar.gz
TERMUX_PKG_SHA256=845b2afd828ea4f5d68e1874e0bfee202d41d118a2a9ccc0d8940735f3be85f9
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, vulkan-loader-generic"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSWIFTSHADER_BUILD_TESTS=FALSE
-DSWIFTSHADER_WARNINGS_AS_ERRORS=FALSE
-DSPIRV_HEADERS_SKIP_INSTALL=ON
-DSKIP_SPIRV_TOOLS_INSTALL=OFF
"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
	LDFLAGS+=" -Wl,-undefined-version"
}

termux_step_make_install() {
	cp libvk_swiftshader.so $TERMUX_PREFIX/lib

	mkdir -p $TERMUX_PREFIX/share/vulkan/icd.d/
	python $TERMUX_PKG_SRCDIR/src/Vulkan/write_icd_json.py \
		--input $TERMUX_PKG_SRCDIR/src/Vulkan/vk_swiftshader_icd.json.tmpl \
		--output $TERMUX_PREFIX/share/vulkan/icd.d/vk_swiftshader_icd.json \
		--library_path $TERMUX_PREFIX/lib/libvk_swiftshader.so
}
