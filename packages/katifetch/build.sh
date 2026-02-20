TERMUX_PKG_HOMEPAGE=https://github.com/ximimoments/katifetch
TERMUX_PKG_DESCRIPTION="Lightweight and customizable system information fetch tool written in POSIX shell"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Katifetch Support <katifetchs@gmail.com>"
TERMUX_PKG_VERSION=13.1
TERMUX_PKG_SRCURL=https://github.com/ximimoments/katifetch/releases/download/${TERMUX_PKG_VERSION}/katifetch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e0f8d6e20cd7dc874c748732e500121b4c6de0f1ea8438ec7d52d461936410c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install -Dm755 katifetch $TERMUX_PREFIX/bin/katifetch
}
