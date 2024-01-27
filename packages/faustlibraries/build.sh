TERMUX_PKG_HOMEPAGE=https://github.com/grame-cncm/faustlibraries
TERMUX_PKG_DESCRIPTION="Faust libraries"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="licenses/stk-4.3.0.md"
TERMUX_PKG_MAINTAINER="@termux, @harieamjari"
TERMUX_PKG_VERSION=2024.01.25
TERMUX_PKG_SRCURL=https://github.com/grame-cncm/faustlibraries/archive/2a5b4ab36e5d47f7e56277b19f41892bcf6378f4.zip
TERMUX_PKG_SHA256=be37b2d32b213996ca2b7ab12c6d282d254dc20a1792c796d26f6bd3bda8bdd6
TERMUX_PKG_DEPENDS="faust"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	:
}

termux_step_make_install() {
	# installs faust libraries to `faust --dspdir`.
	./install
}

