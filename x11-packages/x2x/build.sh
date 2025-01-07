TERMUX_PKG_HOMEPAGE=https://github.com/dottedmag/x2x
TERMUX_PKG_DESCRIPTION="Allows the keyboard, mouse on one X display to be used to control another X display"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.30-10
TERMUX_PKG_SRCURL=https://github.com/dottedmag/x2x/archive/refs/tags/debian/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=f41d5ed55d4b05fe28ab8c07bf41e19cdafcc6ecd08f588679aa0ee48f1eb627
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libx11, libxext, libxtst"

termux_step_pre_configure() {
	./bootstrap.sh
}
