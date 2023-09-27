TERMUX_PKG_HOMEPAGE=https://github.com/kainjow/Mustache
TERMUX_PKG_DESCRIPTION="Mustache implementation for modern C++"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_SRCURL=https://github.com/kainjow/Mustache/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=acd66359feb4318b421f9574cfc5a511133a77d916d0b13c7caa3783c0bfe167
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
	:
}

termux_step_make() {
	:
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/include $TERMUX_PKG_SRCDIR/mustache.hpp
}
