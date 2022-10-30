TERMUX_PKG_HOMEPAGE=https://ranger.github.io/
TERMUX_PKG_DESCRIPTION="File manager with VI key bindings"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.3
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/ranger/ranger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ce088a04c91c25263a9675dc5c43514b7ec1b38c8ea43d9a9d00923ff6cdd251
TERMUX_PKG_DEPENDS="python, file"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

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

termux_step_make() {
	echo Skipping make step...
}

termux_step_make_install() {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	pip install --no-deps . --prefix $TERMUX_PREFIX
}
