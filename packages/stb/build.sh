TERMUX_PKG_HOMEPAGE=https://github.com/nothings/stb
TERMUX_PKG_DESCRIPTION="Single-file public domain (or MIT licensed) libraries for C/C++"
TERMUX_PKG_LICENSE="Public Domain, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.0+g31c1ad37"
TERMUX_PKG_SRCURL="https://github.com/nothings/stb/archive/${TERMUX_PKG_VERSION##*+g}.tar.gz"
TERMUX_PKG_SHA256=e4e3bba9c572a4a4148373a914d88ea0f0d11de8cc2c66739926e7eca0223319
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm 644 *.{c,h} -t "${TERMUX__PREFIX__INCLUDE_DIR}"/stb/
}
