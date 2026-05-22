TERMUX_PKG_HOMEPAGE=https://github.com/Akianonymus/gdrive-downloader
TERMUX_PKG_DESCRIPTION="Download a gdrive folder or file easily, shell ftw"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.0
TERMUX_PKG_SRCURL=https://github.com/Akianonymus/gdrive-downloader/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=0c9cccf7c10b02b31fd1e8b40b8c68b6d2cce34bc1534c7732024a21d637d273
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS='bash, curl'
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -D release/* -t "$TERMUX_PREFIX/bin"
}
