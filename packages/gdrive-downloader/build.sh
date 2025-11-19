TERMUX_PKG_HOMEPAGE=https://github.com/Akianonymus/gdrive-downloader
TERMUX_PKG_DESCRIPTION="Download a gdrive folder or file easily, shell ftw"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.1
TERMUX_PKG_SRCURL=https://github.com/Akianonymus/gdrive-downloader/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=aa1bf1a0a2cd6cc714292b2e83cf38fa37b99aac8f9d80ee92d619f156ddf4ba
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS='bash, curl'
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -D release/bash/* -t "$TERMUX_PREFIX/bin"
}
