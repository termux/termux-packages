TERMUX_PKG_HOMEPAGE=https://github.com/ximimoments/katifetch
TERMUX_PKG_DESCRIPTION="Lightweight and customizable system information fetch tool written in POSIX shell"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Katifetch Support <katifetchs@gmail.com>"
TERMUX_PKG_VERSION=13.1
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_SRCURL=https://github.com/ximimoments/katifetch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=57018797a61ab6befb80a0b76cdf7ca457421ef8cfc030fe41d77a78b017fd30

TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install -Dm755 katifetch.sh \
        $TERMUX_PREFIX/bin/katifetch

    install -d $TERMUX_PREFIX/share/katifetch
    cp -r logos themes assets \
        $TERMUX_PREFIX/share/katifetch/
}
