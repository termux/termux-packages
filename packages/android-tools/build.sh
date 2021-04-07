TERMUX_PKG_HOMEPAGE=https://developer.android.com/
TERMUX_PKG_DESCRIPTION="Android platform tools"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=30.0.5p1
TERMUX_PKG_SRCURL=https://github.com/nmeum/android-tools/releases/download/$TERMUX_PKG_VERSION/android-tools-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=8400387db0ff3c7d030418b9f63ea171917c26e6bcc82d9dc666c8c4c02e9806
TERMUX_PKG_DEPENDS="libc++, libusb, pcre2, googletest, libprotobuf, brotli, zstd, liblz4"

termux_step_pre_configure() {
	termux_setup_protobuf
	termux_setup_golang
}
