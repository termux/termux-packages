TERMUX_PKG_HOMEPAGE=https://github.com/tahoe-lafs/pycryptopp
TERMUX_PKG_DESCRIPTION="Python 2 interfaces to a few good crypto algorithms"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_SRCURL=https://github.com/tahoe-lafs/pycryptopp/archive/pycryptopp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=pycryptopp-pycryptopp-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_make_install () {
	pip install http://pypi.python.org/packages/source/d/distutilscross/distutilscross-0.1.tar.gz

	export PYTHONXCPREFIX=$TERMUX_PREFIX
	export LDSHARED="${CC} -shared -lpython2.7"

	echo "__version__ = '$TERMUX_PKG_VERSION'" > src/pycryptopp/_version.py

	python setup.py build -x
	export PYTHONUSERBASE=$TERMUX_PREFIX/lib/python2.7/site-packages/
	python setup.py install --prefix=$TERMUX_PREFIX --force --user
}

termux_step_post_massage () {
	find . -path '*.pyc' -delete
}
