TERMUX_PKG_HOMEPAGE=https://github.com/Talinx/jp2a/
TERMUX_PKG_DESCRIPTION="A simple JPEG to ASCII converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL=https://github.com/Talinx/jp2a/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=68b9cefc291a9bc5b6210dc3cb29173e7222e49a3aec6cab51b0f5e5e696371f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libexif, libjpeg-turbo, libpng, libwebp, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
bashcompdir=${TERMUX_PREFIX}/share/bash-completion/completions
"

termux_step_pre_configure() {
	autoreconf -vi
}
