TERMUX_PKG_HOMEPAGE=https://pypi.python.org/pypi/lockfile
TERMUX_PKG_DESCRIPTION="Platform-independent file locking module for python 2"
TERMUX_PKG_VERSION=0.12.2
TERMUX_PKG_SRCURL=https://pypi.python.org/packages/source/l/lockfile/lockfile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
        python setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
	find . -path '*.pyc' -delete
}
