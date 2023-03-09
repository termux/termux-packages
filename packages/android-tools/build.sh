TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, vendor/core/fastboot/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=34.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/nmeum/android-tools/releases/download/$TERMUX_PKG_VERSION/android-tools-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f88ec5686937f7fb2f689c3b0506123f2399276a14673164b0f95454a4c7b97a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, brotli, libc++, liblz4, libprotobuf, libusb, pcre2, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="googletest"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_golang

	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}
