TERMUX_PKG_HOMEPAGE=https://github.com/project-mtd/mtd
TERMUX_PKG_DESCRIPTION="A native utility to move and merge directories without overwriting"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Nasa <hastagaming@github.com>"
TERMUX_PKG_VERSION=1.0.0
# URL source code dari GitHub Release atau commit
TERMUX_PKG_SRCURL=https://github.com/project-mtd/mtd/archive/v${TERMUX_PKG_VERSION}.tar.gz
# Hash SHA256 dari file tar.gz tersebut (bisa didapat dengan sha256sum)
TERMUX_PKG_SHA256="864f5641e0242781089b330ac756cc06be6386f720b0d878ea3a3b0625867f2f"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
    # Karena kita pakai Makefile.in & configure.ac,
    # kita perlu generate script configure sebelum build dimulai
    autoreconf -fi
}
#.

