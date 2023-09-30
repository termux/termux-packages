TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="zig/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.11.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/ziglang/zig-bootstrap/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=046cede54ae0627c6ac98a1b3915242b35bc550ac7aaec3ec4cef6904c95019e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_zig
}

termux_step_make() {
	# zig 0.11.0+ uses 3 stages bootstrapping build system
	# which NDK cant be used anymore
	unset AS CC CFLAGS CPP CPPFLAGS CXX CXXFLAGS LD LDFLAGS

	# build.patch skipped various steps to make CI build <6 hours
	./build "${ZIG_TARGET_NAME}" baseline
}

termux_step_make_install() {
	cp -fr "out/zig-${ZIG_TARGET_NAME}-baseline" "${TERMUX_PREFIX}/lib/zig"
	ln -fsv "../lib/zig/zig" "${TERMUX_PREFIX}/bin/zig"
}
