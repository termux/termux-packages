TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="zig/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL=https://github.com/ziglang/zig/releases/download/${TERMUX_PKG_VERSION}/zig-bootstrap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3efc643d56421fa68072af94d5512cb71c61acf1c32512f77c0b4590bff63187
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_zig

	export TERMUX_PKG_MAKE_PROCESSES

	# zig 0.11.0+ uses 3 stages bootstrapping build system
	# which NDK cant be used anymore
	unset AS CC CFLAGS CPP CPPFLAGS CXX CXXFLAGS LD LDFLAGS
}

termux_step_make() {
	# build.patch switch to ninja to make CI build <6 hours
	./build "${ZIG_TARGET_NAME}" baseline
}

termux_step_make_install() {
	cp -fr "out/zig-${ZIG_TARGET_NAME}-baseline" "${TERMUX_PREFIX}/lib/zig"
	ln -fsv "../lib/zig/zig" "${TERMUX_PREFIX}/bin/zig"
}
