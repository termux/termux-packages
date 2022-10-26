TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, vendor/core/fastboot/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=33.0.3p2
TERMUX_PKG_SRCURL=https://github.com/nmeum/android-tools/releases/download/$TERMUX_PKG_VERSION/android-tools-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6bf6b52d7389e79fc92b63cc206451ee42fc4f7da769d76922193e98d75f5604
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="brotli, libc++, liblz4, libprotobuf, libusb, pcre2, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="googletest"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_golang
}
