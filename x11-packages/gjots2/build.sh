TERMUX_PKG_HOMEPAGE=http://bhepple.freeshell.org/gjots
TERMUX_PKG_DESCRIPTION="A hierarchical note jotter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/gjots2/files/gjots2/${TERMUX_PKG_VERSION}/gjots2-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=2bfed1dfbb7c209ff132d736269389397bc3cea7505e2166e78ae33531baa2bf
TERMUX_PKG_DEPENDS="gtksourceview4, pygobject, python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	build-pip install wheel
}

termux_step_make_install() {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	pip install --no-deps . --prefix $TERMUX_PREFIX
}
