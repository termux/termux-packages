TERMUX_PKG_HOMEPAGE="https://github.com/Natarizki/bada-lang"
TERMUX_PKG_DESCRIPTION="Bada programming language compiler - hybrid C with Rust safety"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Natarizki <natarizki@github.com>"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/Natarizki/bada-lang/archive/refs/tags/v1.2.0.tar.gz"
TERMUX_PKG_SHA256="4974361fae81873bd592f1c2c4b84882249187684d4c0b4fbe982c354c71da20"
TERMUX_PKG_DEPENDS="llvm, clang, cmake, ninja"
TERMUX_PKG_BUILD_DEPENDS="llvm-dev, clang"

termux_step_make() {
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DLLVM_DIR=$(llvm-config --cmakedir) \
        -G Ninja \
        "$TERMUX_PKG_SRCDIR"
    ninja
}

termux_step_make_install() {
    install -Dm755 bada "$TERMUX_PREFIX/bin/bada"
}
