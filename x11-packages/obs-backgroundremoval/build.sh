TERMUX_PKG_HOMEPAGE="https://github.com/royshil/obs-backgroundremoval"
TERMUX_PKG_DESCRIPTION="Portrait background removal/virtual green-screen and low-light enhancement for obs studio"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_SRCURL="https://github.com/royshil/obs-backgroundremoval/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e897daccd05bc605ffa0ff1adf103bbf5db31218b7c15166fc71bf6fa6c57772
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="obs-studio, onnxruntime, opencv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_OUT_OF_TREE=ON
-DCMAKE_CXX_SCAN_FOR_MODULES=OFF
-DOpenCV_DIR=${TERMUX_PREFIX}/lib/cmake/opencv4
"

termux_step_pre_configure() {
	# Ensuring the compiler can find OpenCV headers in the Termux prefix
	CXXFLAGS+=" -I${TERMUX_PREFIX}/include/opencv4"

	# XNNPACK's generate-microkernels.py fails under 32-bit bionic cross-compilation.
	# Disable XNNPACK on 32-bit architectures to fall back to the generic CPU provider.
	if [ "$TERMUX_ARCH" = "arm" ] || [ "$TERMUX_ARCH" = "i686" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Donnxruntime_USE_XNNPACK=OFF"
	fi
}
