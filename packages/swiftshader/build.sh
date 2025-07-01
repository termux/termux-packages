TERMUX_PKG_HOMEPAGE=https://swiftshader.googlesource.com/SwiftShader
TERMUX_PKG_DESCRIPTION="A high-performance CPU-based implementation of the Vulkan graphics API"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT_DATE=2025.06.25
_COMMIT_HASH=436722b391188ad8c1d1d5dd2447c38ac7f71439
TERMUX_PKG_VERSION=$_COMMIT_DATE
TERMUX_PKG_SRCURL=https://github.com/google/swiftshader/archive/$_COMMIT_HASH.tar.gz
TERMUX_PKG_SHA256=971423bdf3e5890234bc9d9f82e7d6e648b2533f8e2dfe4265c3209b831dfd06
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
