TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software. (nightly version)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=0.10.0-dev.3385+c0a1b4fa4
TERMUX_PKG_SRCURL=https://ziglang.org/download/$TERMUX_PKG_VERSION/zig-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=ea1a28f1240a5ea00efb7047cd553e46fbe505a33173b4ed5eae12a0793dcad9
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libxml2, ncurses, zlib"
TERMUX_PKG_BUILD_DEPENDS="llvm, libllvm-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DZIG_PREFER_CLANG_CPP_DYLIB=OFF
-DLLVM_LIBDIRS=$TERMUX_PREFIX/lib
"
TERMUX_PKG_CONFLICTS="neovim"
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local version="$(curl -L https://ziglang.org/download/index.json | jq ".master.version")"
	local sha256="$(curl -L https://ziglang.org/download/index.json | jq "del(.master) | .master.src.shasum")"
	sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" -e "s|^TERMUX_PKG_VERSION=.*|TERMUX_PKG_VERSION=$version|"
	sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" -e "s|^TERMUX_PKG_SHA256=.*|TERMUX_PKG_SHA256=$sha256|"
}

termux_step_pre_configure() {
	termux_setup_zig
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DZIG_EXECUTABLE=$(command -v zig)
		-DZIG_TARGET_TRIPLE=$ZIG_TARGET_NAME
		"
	LDFLAGS+=" -landroid-spawn -lncursesw -lxml2 -lz"
}
