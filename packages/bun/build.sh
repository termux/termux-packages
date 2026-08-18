TERMUX_PKG_HOMEPAGE=https://bun.com
TERMUX_PKG_DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.3.14"
TERMUX_PKG_REVISION=1

# Bun v1.3.14 shipped 1st-party native Android builds (see
# https://bun.com/blog/bun-v1.3.14#freebsd-and-android-support). These are
# PIE binaries linked only against libc.so/libm.so/libdl.so (verified with
# `file` + `readelf -d`) and use Android's own dynamic linker
#
# Only aarch64 and x86_64 Android builds exist upstream (no arm/i686), so
# this package is restricted to those two architectures.
if [ "$TERMUX_ARCH" = "x86_64" ]; then
	_BUN_ARCH=x64
else
	_BUN_ARCH="$TERMUX_ARCH"
fi

TERMUX_PKG_SRCURL="https://github.com/oven-sh/bun/releases/download/bun-v${TERMUX_PKG_VERSION}/bun-linux-${_BUN_ARCH}-android.zip"
TERMUX_PKG_SHA256=992bcf239c91bedd873f8150cceef3db3b0618fa78161badd3c14dc6d24fe560
TERMUX_PKG_SHA256_aarch64=992bcf239c91bedd873f8150cceef3db3b0618fa78161badd3c14dc6d24fe560
TERMUX_PKG_SHA256_x86_64=9ce0fccae24c55c5e59f6ee87c6defd8c79d0dc8a9ad2c214abd177c23c31d27
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true

# TERMUX_PKG_AUTO_UPDATE currently disabled: upstream's Android asset names
# and availability are new (v1.3.14+), so auto-update is left off until
# that's proven stable across a few releases. Bump TERMUX_PKG_VERSION and
# the two TERMUX_PKG_SHA256 values above manually for now.

termux_step_make() {
	: # nothing to build -- prebuilt binary
}

termux_step_make_install() {
	install -Dm755 \
		"$TERMUX_PKG_SRCDIR/bun" \
		"$TERMUX_PREFIX/bin/bun"
}

termux_step_post_get_source() {
	# download bun license file
	curl -fsSL "https://raw.githubusercontent.com/oven-sh/bun/main/LICENSE.md" -o "$TERMUX_PKG_SRCDIR/LICENSE"
}
