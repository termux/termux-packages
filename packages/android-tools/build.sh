TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, vendor/core/fastboot/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="36.0.1"
TERMUX_PKG_SRCURL="https://github.com/nmeum/android-tools/releases/download/$TERMUX_PKG_VERSION/android-tools-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=38e8a84b739480141de0836bf6d581b3339ac7d53d0f7ce8c044a3368c8c2f8f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, brotli, fmt, libc++, liblz4, libprotobuf, pcre2, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="googletest"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_TOOLS_USE_BUNDLED_LIBUSB=ON
"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_golang

	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}
