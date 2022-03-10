TERMUX_PKG_HOMEPAGE=https://xon.sh
TERMUX_PKG_DESCRIPTION="Python-powered, cross-platform, Unix-gazing shell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.11.0
TERMUX_PKG_SRCURL=https://github.com/xonsh/xonsh/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d73273276996297920c234c7d4267a305c695f0e9e2454dbdf0655c3a8f75cb
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
_PYTHON_VERSION=3.10

termux_setup_make_install() {
	python${_PYTHON_VERSION} setup.py install --force --prefix=${TERMUX_PREFIX}
}

termux_step_create_debscripts() {
        echo "#!$TERMUX_PREFIX/bin/sh" > postinst
        echo "pip3 install 'pygments' 'prompt-toolkit' 'setproctitle'" >> postinst
}
