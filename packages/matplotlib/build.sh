TERMUX_PKG_HOMEPAGE=https://matplotlib.org/
TERMUX_PKG_DESCRIPTION="A comprehensive library for creating static, animated, and interactive visualizations in Python"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="\
LICENSE/LICENSE
LICENSE/LICENSE_AMSFONTS
LICENSE/LICENSE_BAKOMA
LICENSE/LICENSE_CARLOGO
LICENSE/LICENSE_COLORBREWER
LICENSE/LICENSE_COURIERTEN
LICENSE/LICENSE_JSXTOOLS_RESIZE_OBSERVER
LICENSE/LICENSE_QHULL
LICENSE/LICENSE_QT4_EDITOR
LICENSE/LICENSE_SOLARIZED
LICENSE/LICENSE_STIX
LICENSE/LICENSE_YORICK"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/matplotlib/matplotlib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d39f9a93881b443bae6fbe73bf9c71dc2eb5b1921d9dcf1c97807f37728d459b
TERMUX_PKG_DEPENDS="freetype, libc++, python, python-numpy, python-pillow, python-pip"
TERMUX_PKG_PYTHON_TARGET_DEPS="'contourpy>=1.0.1', 'cycler>=0.10', 'fonttools>=4.22.0', 'kiwisolver>=1.0.1', 'numpy>=1.19', 'packaging>=20.0', 'pyparsing>=2.2.1', 'python-dateutil>=2.7'"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, numpy, setuptools_scm, setuptools_scm_git_archive, wheel"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip. This may take a while..."
	MATHLIB="m" pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
