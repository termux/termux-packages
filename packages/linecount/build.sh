TERMUX_PKG_HOMEPAGE=https://github.com/qw123456qwe/linecount
TERMUX_PKG_DESCRIPTION="Tiny file statistics viewer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="qw123456qwe"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_SRCURL=https://github.com/qw123456qwe/linecount/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install -Dm700 linecount \
        $TERMUX_PREFIX/bin/linecount
}
