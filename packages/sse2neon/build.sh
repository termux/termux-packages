TERMUX_PKG_HOMEPAGE=https://github.com/DLTcollab/sse2neon
TERMUX_PKG_DESCRIPTION="A C/C++ header file that converts Intel SSE intrinsics to Arm/Aarch64 NEON intrinsics"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL=https://github.com/DLTcollab/sse2neon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e251746e3b761f3f0de1ad462b1efe53532341b6b0498d394765fceb85ce8a46
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# dont build tests
	:
}

termux_step_make_install() {
	# Makefile dont have install rule
	install -Dm600 sse2neon.h "${TERMUX_PREFIX}"/include
}
