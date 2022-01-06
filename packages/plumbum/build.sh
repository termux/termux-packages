TERMUX_PKG_HOMEPAGE=https://plumbum.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Plumbum: shell combinators"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.2
TERMUX_PKG_SRCURL=https://github.com/tomerfiliba/plumbum/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fa82147485b7346509ba30c64a19b4204b994b15a0f056ab007505ea087fd2e2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
_PYTHON_VERSION=3.10
termux_step_pre_configure() {
	pip install setuptools_scm
}
termux_step_make_install() {
	cd ${TERMUX_PKG_SRCDIR}
	export SETUPTOOLS_SCM_PRETEND_VERSION=${TERMUX_PKG_VERSION}
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	export CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}"
	export LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	export LDSHARED="$CC -shared"
	python${_PYTHON_VERSION} setup.py install --prefix=$TERMUX_PREFIX --force
}
