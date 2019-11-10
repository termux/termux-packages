TERMUX_PKG_HOMEPAGE=https://github.com/adrianlopezroche/fdupes
TERMUX_PKG_DESCRIPTION="Duplicates file detector"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/adrianlopezroche/fdupes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d6b6fdb0b8419815b4df3bdfd0aebc135b8276c90bbbe78ebe6af0b88ba49ea
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
    sed -i "s,PREFIX = /usr/local,PREFIX = ${TERMUX_PREFIX}," "$TERMUX_PKG_SRCDIR/Makefile"
}

