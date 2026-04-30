TERMUX_PKG_HOMEPAGE="https://github.com/upscayl/upscayl-ncnn"
TERMUX_PKG_DESCRIPTION="Fork of the NCNN implementation of Real-ESRGAN"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	"20251207-174704"
	"v0.2.5.0"
)

TERMUX_PKG_SRCURL=(
	"https://github.com/upscayl/upscayl-ncnn/archive/refs/tags/${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/xinntao/Real-ESRGAN/releases/download/${TERMUX_PKG_VERSION[1]}/realesrgan-ncnn-vulkan-20220424-ubuntu.zip"
)

TERMUX_PKG_SHA256=(
	"a795c6b8950e7e88434f07ae352182b2bf38f229894b61d8196ac985758115fe"
	"e5aa6eb131234b87c0c51f82b89390f5e3e642b7b70f2b9bbe95b6a285a40c96"
)

TERMUX_PKG_DEPENDS="libwebp, libncnn"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, vulkan-loader-android, glslang, shaderc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=OFF
-DUSE_SYSTEM_NCNN=ON
-DUSE_SYSTEM_WEBP=ON
-DGLSLANG_TARGET_DIR=${TERMUX_PREFIX}/lib/cmake
-DCMAKE_DISABLE_FIND_PACKAGE_OpenMP=TRUE
"

termux_step_pre_configure() {
	export CMAKE_LIBRARY_PATH="$TERMUX_PREFIX/lib"
	export CMAKE_INCLUDE_PATH="$TERMUX_PREFIX/include"
	TERMUX_PKG_SRCDIR+="/src"
}

termux_step_make_install() {
	install -Dm755 upscayl-bin "${TERMUX_PREFIX}/lib/upscayl/upscayl"
	install -d "${TERMUX_PREFIX}/bin"
	ln -sf "${TERMUX_PREFIX}/lib/upscayl/upscayl" "${TERMUX_PREFIX}/bin/upscayl"
	ln -sf "${TERMUX_PREFIX}/lib/upscayl/upscayl" "${TERMUX_PREFIX}/bin/upscayl-bin"
	install -d "${TERMUX_PREFIX}/lib/upscayl/models"
	unzip -q -o "${TERMUX_PKG_CACHEDIR}/realesrgan-ncnn-vulkan-20220424-ubuntu.zip" -d models_extract
	cp -r models_extract/models/* "${TERMUX_PREFIX}/lib/upscayl/models/"
}
