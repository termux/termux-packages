TERMUX_PKG_HOMEPAGE="https://github.com/tareksander/termux-gui-package"
TERMUX_PKG_DESCRIPTION="A Termux package containing utilities for Termux:GUI"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@tareksander"
TERMUX_PKG_VERSION="0.1.6"
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SRCURL="https://github.com/tareksander/termux-gui-package/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="79a231f6550bde39c0bdd4eca0fce91b21df9c817345072c4859567437e485bf"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	echo "Installing python bindings for Termux:GUI"
	pip install --upgrade termuxgui
	EOF
}
