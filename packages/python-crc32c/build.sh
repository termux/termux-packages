TERMUX_PKG_HOMEPAGE=https://github.com/ICRAR/crc32c
TERMUX_PKG_DESCRIPTION="Python package implementing the crc32c checksum algorithm in hardware and software"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.google-crc32c, LICENSE.slice-by-8"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.8"
TERMUX_PKG_SRCURL="https://github.com/ICRAR/crc32c/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1495beffd55781e41f915132085eda6a169d849cb69e434fced89f85ccea1497
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_configure() {
	# Upstream enables the ARMv8 CRC and crypto (PMULL) intrinsics on
	# aarch64 with the GCC-only construct
	# `#pragma GCC target ("+crc+crypto")` in
	# src/crc32c/ext/crc32c_arm64.c. Clang treats this as an unrecognized
	# pragma (it only supports enabling target features through
	# `__attribute__((target(...)))`), so the pragma is silently ignored
	# and the always_inline `__crc32cd()`/`vmull_p64()` intrinsics end up
	# compiled without the "crc"/"aes" target features, which fails with
	# e.g.:
	#   error: always_inline function '__crc32cd' requires target feature
	#   'crc', but would be inlined into function '_crc32c_hw_arm64' that
	#   is compiled without support for 'crc'
	#   error: always_inline function 'vmull_p64' requires target feature
	#   'aes', but would be inlined into function '_crc32c_hw_arm64' that
	#   is compiled without support for 'aes'
	# Work around this by enabling both features for the whole
	# translation unit so the (ineffective) pragma becomes a harmless
	# no-op. "crypto" implies "aes" (and "sha2") on the aarch64 target.
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		CFLAGS+=" -march=armv8-a+crc+crypto"
	fi
}

termux_step_make() {
	:
}

termux_step_make_install() {
	pip install . --prefix="$TERMUX_PREFIX" --no-build-isolation --no-deps
}
