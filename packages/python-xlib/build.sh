TERMUX_PKG_HOMEPAGE=https://github.com/python-xlib/python-xlib
TERMUX_PKG_DESCRIPTION="The Python X Library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.33
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/python-xlib/python-xlib/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e10d1b49655800bffe0fbb5eb31eeef915a4421952ef006d468d53d34901f6f8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-pip"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="'six>=1.10.0'"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip. This may take a while..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
