TERMUX_PKG_HOMEPAGE=https://github.com/tLDP/python-tldp
TERMUX_PKG_DESCRIPTION="Tools for publishing from TLDP sources"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tLDP/python-tldp/archive/refs/tags/tldp-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bae313095b877b4272ddccaabd70efcbc526e2c1036f63fb665ec7ce10c94cde
TERMUX_PKG_DEPENDS="python"
_PKG_PYTHON_DEPENDS="networkx nose"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
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
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	pip install --no-deps . --prefix $TERMUX_PREFIX
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${_PKG_PYTHON_DEPENDS}
	EOF
}
