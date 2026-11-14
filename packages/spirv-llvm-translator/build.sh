TERMUX_PKG_HOMEPAGE=https://github.com/KhronosGroup/SPIRV-LLVM-Translator
TERMUX_PKG_DESCRIPTION="SPIR-V LLVM Translator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="21.1.13"
_SPIRV_HEADERS_COMMIT=cb42dec3830d3ac67fa449ecdc0c0f73d5e74498
TERMUX_PKG_SRCURL=(
	"https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	"https://github.com/KhronosGroup/SPIRV-Headers/archive/${_SPIRV_HEADERS_COMMIT}.tar.gz"
)
TERMUX_PKG_SHA256=(
	f80d32d266df54eeb75e41b87ed4ea4bfdbe8f0eaea510de1d7cc3f088ebbd9d
	117010e525fe36b1ce006e0e58a6e0a3b415aabc9179d912b92737f41f3f994f
)
TERMUX_PKG_DEPENDS="libc++, libllvm (<< $TERMUX_LLVM_NEXT_MAJOR_VERSION)"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static, spirv-tools"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="21.\d+\.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBASE_LLVM_VERSION=${TERMUX_LLVM_VERSION}
"

termux_step_post_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR/spirv-headers"
	tar -xf "$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[1]}")" \
		-C "$TERMUX_PKG_SRCDIR/spirv-headers" --strip-components=1
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=$TERMUX_PKG_SRCDIR/spirv-headers"
}
