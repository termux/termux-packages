TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f4f4a04ab891dd513c99f72527c83fa9e634e858f2744a17e80258b90a6bf409
TERMUX_PKG_AUTO_UPDATE=true
# ncurses-utils for tput which asciinema uses:
TERMUX_PKG_DEPENDS="python, ncurses-utils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_HAS_DEBUG=false

_PYTHON_VERSION=3.10

TERMUX_PKG_RM_AFTER_INSTALL="
lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
lib/python${_PYTHON_VERSION}/site-packages/site.py
lib/python${_PYTHON_VERSION}/site-packages/__pycache__
"

termux_step_make() {
	return
}

termux_step_make_install() {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/
	python${_PYTHON_VERSION} setup.py install --prefix=$TERMUX_PREFIX --force
}
