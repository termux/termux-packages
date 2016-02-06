TERMUX_PKG_HOMEPAGE=http://duplicity.nongnu.org/
TERMUX_PKG_DESCRIPTION="Encrypted bandwidth-efficient backup using the rsync algorithm"
TERMUX_PKG_VERSION=0.7.06
TERMUX_PKG_SRCURL=https://code.launchpad.net/duplicity/0.7-series/${TERMUX_PKG_VERSION}/+download/duplicity-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="librsync, python2, python2-lockfile"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_make_install () {
	pip install http://pypi.python.org/packages/source/d/distutilscross/distutilscross-0.1.tar.gz

	export PYTHONXCPREFIX=$TERMUX_PREFIX
	export LDSHARED="${CC} -shared -lpython2.7"

	python setup.py build -x
	python setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
	find . -path '*.pyc' -delete
}
