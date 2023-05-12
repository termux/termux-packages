# x11-packages
TERMUX_PKG_HOMEPAGE=https://github.com/python-xlib/python-xlib
TERMUX_PKG_DESCRIPTION="A fully functional X client library for Python programs"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_REVISION=23
TERMUX_PKG_SRCURL=https://github.com/python-xlib/python-xlib/releases/download/${TERMUX_PKG_VERSION}/python-xlib-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7ecf32b18b59be2c06848410bae848792ead119ac31084f487730581b3ab598c
TERMUX_PKG_DEPENDS="libx11, python2, python2-six"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	return
}

termux_step_make_install() {
	## python2 setuptools needed
	export PYTHONPATH=${TERMUX_PREFIX}/lib/python2.7/site-packages/
	python2.7 setup.py install --root="/" --prefix="${TERMUX_PREFIX}" --force
}
