TERMUX_PKG_HOMEPAGE=https://emscripten.org/
TERMUX_PKG_DESCRIPTION="Emscripten is a complete compiler toolchain to WebAssembly, using LLVM, with a special focus on speed, size, and the Web platform."
TERMUX_PKG_LICENSE="MIT/Expat"
TERMUX_PKG_VERSION=2.0.8
TERMUX_PKG_SRCURL=htps://github.com/emscripten-core/emsdk/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=248d716dbe2e2424ee3f205c41024b4efde974e8987f2204a97edb315c588ff3
TERMUX_PKG_DEPENDS="LLVM"
TERMUX_PKG_BUILD_DEPENDS="python3, node, java"

termux_step_make_install() {
    ./emsdk install latest
  
}
