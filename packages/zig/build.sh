TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_SRCURL=https://ziglang.org/download/$TERMUX_PKG_VERSION/zig-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=cd1be83b12f8269cc5965e59877b49fdd8fa638efb6995ac61eb4cea36a2e381
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libxml2, ncurses, zlib"
TERMUX_PKG_BUILD_DEPENDS="llvm, libllvm-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DZIG_PREFER_CLANG_CPP_DYLIB=OFF
-DLLVM_LIBDIRS=$TERMUX_PREFIX/lib
"

termux_step_pre_configure() {
	termux_setup_zig
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DZIG_EXECUTABLE=$(which zig)
		-DZIG_TARGET_TRIPLE=$ZIG_TARGET_NAME
		"
	LDFLAGS+=" -landroid-spawn -lncursesw -lxml2 -lz"
}
