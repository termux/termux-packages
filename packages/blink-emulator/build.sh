TERMUX_PKG_HOMEPAGE=https://justine.lol/blinkenlights/
TERMUX_PKG_DESCRIPTION="Tiniest x86-64-linux emulator"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL=https://github.com/jart/blink/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=38757098cdc9822399fe6eedb9529cc8c79ee44396bbecddce65fb9b7bbb47f9
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	export LDFLAGS+=" -lm -lz"
}

termux_step_configure() {
	# custom configure script that errors instead of ignores
	# unknown arguments
	./configure --prefix="${TERMUX_PREFIX}"
}
