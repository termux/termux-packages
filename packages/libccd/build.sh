TERMUX_PKG_HOMEPAGE="https://github.com/danfis/libccd"
TERMUX_PKG_DESCRIPTION="Library for collision detection between two convex shapes"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="BSD-LICENSE"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="2.1"
TERMUX_PKG_SRCURL="https://github.com/danfis/libccd/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=542b6c47f522d581fbf39e51df32c7d1256ac0c626e7c2b41f1040d4b9d50d1e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
-DBUILD_DOCUMENTATION=ON
-DBUILD_SHARED_LIBS=ON
-DBUILD_TESTING=OFF
-DCMAKE_BUILD_TYPE=Release
'

termux_step_pre_configure() {
	# Use double-precision for 64-bit archs, otherwise use single-precision
	case "$TERMUX_ARCH" in
		"aarch64" |  "x86_64")
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DENABLE_DOUBLE_PRECISION=ON'
			;;
		"arm" | "i686")
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DENABLE_DOUBLE_PRECISION=OFF'
			;;
		*)
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DENABLE_DOUBLE_PRECISION=OFF'
			;;
	esac
	# Add path of system 'libm' library to cmake
	export CMAKE_LIBRARY_PATH+="$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL"
}
