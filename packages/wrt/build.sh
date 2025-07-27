TERMUX_PKG_HOMEPAGE=https://github.com/lavacraft239/Wrt-benchmark
TERMUX_PKG_DESCRIPTION="Multi-thread HTTP/RTMP benchmarking tool using libcurl and pthread"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Lavacraft239 <santiagomanzolillo@email.com>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/lavacraft239/Wrt-benchmark/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc2192f4ed98e74541594da19bb3163f7c288f838b31ba8a380f858db0a0a288
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    make
}

termux_step_make_install() {
    install -Dm700 wrt $TERMUX_PREFIX/bin/wrt
}
