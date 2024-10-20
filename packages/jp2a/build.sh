TERMUX_PKG_HOMEPAGE=https://github.com/Talinx/jp2a/
TERMUX_PKG_DESCRIPTION="A simple JPEG to ASCII converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_SRCURL=https://github.com/Talinx/jp2a/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b811d8b1f29d47b9526c99174aea848ed14b4ad051787b6fd739d5df2234a51b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libexif, libjpeg-turbo, libpng, libwebp, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
bashcompdir=${TERMUX_PREFIX}/share/bash-completion/completions
"

termux_step_pre_configure() {
	autoreconf -vi
}
