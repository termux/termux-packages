TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=33.0.3
TERMUX_PKG_SRCURL=https://github.com/nmeum/android-tools/releases/download/$TERMUX_PKG_VERSION/android-tools-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=8ce174dab781d5debd29ed0f96572231f777bee19b8ef3c167e33d3ea7670bc5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libusb, pcre2, googletest, libprotobuf, brotli, zstd, liblz4"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_golang
}
