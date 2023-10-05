TERMUX_PKG_HOMEPAGE="https://github.com/itchyny/bed"
TERMUX_PKG_DESCRIPTION="Binary editor written in GO"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.4"
TERMUX_PKG_SRCURL="https://github.com/itchyny/bed/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=01d0a28a8e0b66dc73370de2c2b22368ca9c653bf6c7ae4b3bc2f13af42bc788
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true


termux_step_make() {
        termux_setup_golang
        go build -ldflags="-s -w" -o bed ./cmd/bed
	}

termux_step_make_install() {
        install -Dm700 -t $TERMUX_PREFIX/bin bed
}
