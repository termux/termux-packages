TERMUX_PKG_HOMEPAGE="https://github.com/tareksander/termux-gui-pm"
TERMUX_PKG_DESCRIPTION="A graphical package manager for various package formats for Termux and proot-distro distros"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@tareksander"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SRCURL="https://github.com/tareksander/termux-gui-pm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="3a5a829b721d17f2002406571852e63d1984acc9732e58f2f76a2966381297c6"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_PYTHON_TARGET_DEPS="termuxgui"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	echo "Installing python bindings for Termux:GUI"
	pip3 install --upgrade $TERMUX_PKG_PYTHON_TARGET_DEPS
	EOF
}
 
