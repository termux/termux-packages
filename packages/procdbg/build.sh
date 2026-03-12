TERMUX_PKG_HOMEPAGE=https://github.com/JeckAsChristopher/procdbg
TERMUX_PKG_DESCRIPTION="Cross-platform process debugger supporting ELF, PE, and Mach-O binaries"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Jeck Christopher Anog jeck.christopher1224@gmail.com"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://github.com/JeckAsChristopher/procdbg/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256="b3e59c16ee9470569a626948ccc6e29c2c44c1c1bbbc7612b9dd7aa0f48fb083"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    cmake -B build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX" \
        -DCMAKE_CROSSCOMPILING=TRUE \
        -DCMAKE_SYSTEM_NAME=Android
    cmake --build build -j"$TERMUX_MAKE_PROCESSES"
}

termux_step_make_install() {
    install -Dm755 build/udebug "$TERMUX_PREFIX/bin/udebug"
    install -Dm644 udebug.conf "$TERMUX_PREFIX/etc/udebug/udebug.conf"
    install -Dm644 README.md "$TERMUX_PREFIX/share/doc/udebug/README.md"
    install -Dm644 LICENSE "$TERMUX_PREFIX/share/doc/udebug/LICENSE"
}
