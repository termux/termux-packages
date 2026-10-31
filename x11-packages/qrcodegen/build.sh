TERMUX_PKG_HOMEPAGE=https://github.com/nayuki/QR-Code-generator
TERMUX_PKG_DESCRIPTION="High-quality C and C++ QR Code generator library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SRCURL=(
	"https://github.com/EasyCoding/qrcodegen-cmake/archive/refs/tags/v${TERMUX_PKG_VERSION}-cmake5.tar.gz"
	"https://github.com/nayuki/QR-Code-generator/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
)
TERMUX_PKG_SHA256=(
	4934809f7aec62aafe6fc4346d6402ef6c6fa26659ba5161682b5bbac0029640
	2ec0a4d33d6f521c942eeaf473d42d5fe139abcfa57d2beffe10c5cf7d34ae60
)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQRCODEGEN_BUILD_EXAMPLES=OFF
-DQRCODEGEN_BUILD_TESTS=OFF
-DBUILD_SHARED_LIBS=ON
"

termux_step_post_get_source() {
	# Pull the source folders out of the secondary tarball's directory
	mv "QR-Code-generator-${TERMUX_PKG_VERSION}/c" ./
	mv "QR-Code-generator-${TERMUX_PKG_VERSION}/cpp" ./
}
