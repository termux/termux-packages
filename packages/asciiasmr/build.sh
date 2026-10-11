TERMUX_PKG_HOMEPAGE=https://gg.elitehub.page.gd/
TERMUX_PKG_DESCRIPTION="Terminal-native generative ambience playground"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="Xenostopical <338152768+Xenostopical@users.noreply.github.com>"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/Xenostopical/ascii-asmr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d0a216b217d09384d60783b41febf7e57ada0ac9314212853eb2c120608b6d4d
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    make install PREFIX="$TERMUX_PREFIX"
}
