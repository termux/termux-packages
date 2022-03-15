TERMUX_PKG_HOMEPAGE=https://apt-team.pages.debian.net/python-apt/
TERMUX_PKG_DESCRIPTION="Python bindings for APT"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=de4a284bc7a738793615631d451524f42404034f4d787953b7621b25bc29e474
TERMUX_PKG_DEPENDS="apt, libc++, python"
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

	pushd ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages
	patch --silent -p1 < $TERMUX_PKG_BUILDER_DIR/setuptools-44.1.1-no-bdist_wininst.diff || :
	popd

	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
}

termux_step_make_install() {
	DEBVER=$TERMUX_PKG_VERSION \
		python setup.py install --force --prefix $TERMUX_PREFIX
}
