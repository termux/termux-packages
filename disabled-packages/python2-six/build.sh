# x11-packages
TERMUX_PKG_HOMEPAGE=https://pypi.org/project/six/
TERMUX_PKG_DESCRIPTION="Python 2 and 3 compatibility utilities"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.0
TERMUX_PKG_REVISION=23
TERMUX_PKG_SRCURL=https://pypi.io/packages/source/s/six/six-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	return
}

termux_step_make_install() {
	export PYTHONPATH=${TERMUX_PREFIX}/lib/python2.7/site-packages/
	python2.7 setup.py install --prefix="${TERMUX_PREFIX}" --force
}
