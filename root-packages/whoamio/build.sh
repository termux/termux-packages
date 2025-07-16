TERMUX_PKG_HOMEPAGE=https://github.com/Zamanhuseyinli/whoamio
TERMUX_PKG_DESCRIPTION="IO agent shell tool - process IO visualizer with ncurses interface"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Zamanhuseyinli"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_SRCURL=https://raw.githubusercontent.com/Zamanhuseyinli/whoamio/refs/heads/main/whoamio.sh
TERMUX_PKG_SHA256=2243b0f071e905c0a905ca8338c63f6c69fc9c5251320e48186ed02c5471ff15
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_DEPENDS="shc"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    shc -f whoamio.sh -o whoamio
}

termux_step_make_install() {
    install -Dm700 whoamio "$PREFIX/bin/whoamio"
}
