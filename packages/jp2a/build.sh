TERMUX_PKG_HOMEPAGE=https://github.com/cslarsen/jp2a
TERMUX_PKG_DESCRIPTION="A simple JPEG to ASCII converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.8
TERMUX_PKG_REVISION=5
_COMMIT=61d205f6959d88e0cc8d8879fe7d66eb0932ecca
TERMUX_PKG_SRCURL=https://github.com/cslarsen/jp2a/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=26f655e4b977bf24b8193150f34c015195c07c1116d064375223dd46ea5b8b4e
TERMUX_PKG_DEPENDS="libcurl, libjpeg-turbo, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vi
}
