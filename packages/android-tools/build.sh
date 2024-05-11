TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, vendor/core/fastboot/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="35.0.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/nmeum/android-tools/releases/download/$TERMUX_PKG_VERSION/android-tools-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=654030c7f96d25d7224cd6861fac14a043cf1d3980f40288cdfbe219f94ffaf9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, brotli, libc++, liblz4, libprotobuf, libusb, pcre2, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="googletest"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_golang

	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}
