TERMUX_PKG_HOMEPAGE=https://github.com/Akianonymus/gdrive-downloader
TERMUX_PKG_DESCRIPTION="Download a gdrive folder or file easily, shell ftw"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.0
TERMUX_PKG_SRCURL=https://github.com/Akianonymus/gdrive-downloader/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=26c726bce41bff3b58c1f819a5c1f2e54d66b4ee3d592a5d52088de605c48d95
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS='bash, curl'
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -D release/bash/* -t "$TERMUX_PREFIX/bin"
}
