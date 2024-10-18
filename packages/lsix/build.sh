TERMUX_PKG_HOMEPAGE=https://github.com/hackerb9/lsix
TERMUX_PKG_DESCRIPTION="Shows thumbnails in terminal using sixel graphics"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.1"
TERMUX_PKG_SRCURL=https://github.com/hackerb9/lsix/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=310e25389da13c19a0793adcea87f7bc9aa8acc92d9534407c8fbd5227a0e05d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, imagemagick"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin lsix
}
