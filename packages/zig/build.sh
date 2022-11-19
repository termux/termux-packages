TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SRCURL=https://ziglang.org/download/$TERMUX_PKG_VERSION/zig-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=d8409f7aafc624770dcd050c8fa7e62578be8e6a10956bca3c86e8531c64c136
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-spawn, libc++, libxml2, ncurses, zlib"
TERMUX_PKG_BUILD_DEPENDS="llvm, libllvm-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DZIG_PREFER_CLANG_CPP_DYLIB=OFF
-DLLVM_LIBDIRS=$TERMUX_PREFIX/lib
"

termux_pkg_auto_update() { 
    local version="$(curl -L https://ziglang.org/download/index.json | jq "del(.master) | keys | last(.[])")" 
    local src_sha256="$(curl -L https://ziglang.org/download/index.json | jq "del(.master) | .\"$version\".src.shasum")" 
    local prebuilt_sha256="$(curl -L https://ziglang.org/download/index.json | jq "del(.master) | .\"$version\".x86_64-linux.shasum")" 
    sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" -e "s|^TERMUX_PKG_VERSION=.*|TERMUX_PKG_VERSION=$version|" 
    sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" -e "s|^TERMUX_PKG_SHA256=.*|TERMUX_PKG_SHA256=$src_sha256|" 
    sed -i "${TERMUX_PKG_BUILDER_DIR}/../../scripts/build/setup/termux_setup_zig.sh" -e "s|^ZIG_VERSION=.*|ZIG_VERSION=$version|" 
    sed -i "${TERMUX_PKG_BUILDER_DIR}/../../scripts/build/setup/termux_setup_zig.sh" -e "s|^ZIG_SHA256=.*|ZIG_SHA256=$prebuilt_sha256|" 
}

termux_step_pre_configure() {
	termux_setup_zig
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DZIG_EXECUTABLE=$(command -v zig)
		-DZIG_TARGET_TRIPLE=$ZIG_TARGET_NAME
		"
        LDFLAGS+=" -landroid-support -landroid-spawn -lncursesw -lxml2 -lz $($CC -print-libgcc-file-name)"
}
