TERMUX_PKG_HOMEPAGE=https://python-future.org
TERMUX_PKG_DESCRIPTION="Clean single-source support for Python 3 and 2"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@fervi"
TERMUX_PKG_VERSION=0.18.2
TERMUX_PKG_SRCURL=https://github.com/PythonCharmers/python-future/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=43c1feae4170742671ffef900acd5dbe7c72099aa602d58e95e22c2174edd057
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

termux_step_pre_configure() {
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
}

termux_step_make_install() {
	DEBVER=$TERMUX_PKG_VERSION \
		python setup.py install --force --prefix $TERMUX_PREFIX
}
