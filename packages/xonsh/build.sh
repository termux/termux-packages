TERMUX_PKG_HOMEPAGE=https://xon.sh/
TERMUX_PKG_DESCRIPTION="Xonsh is a Python-powered, cross-platform, Unix-gazing shell language and command prompt. "
TERMUX_PKG_LICENSE=custom
TERMUX_PKG_LICENSE_FILE=license
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.11.0
TERMUX_PKG_SRCURL=https://github.com/xonsh/xonsh/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d73273276996297920c234c7d4267a305c695f0e9e2454dbdf0655c3a8f75cb
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
_PYTHON_VERSION=3.10
termux_step_make_install() {
	cd ${TERMUX_PKG_SRCDIR}
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	export CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}"
	export LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	export LDSHARED="$CC -shared"
	python${_PYTHON_VERSION} setup.py install --prefix=$TERMUX_PREFIX --force
}

