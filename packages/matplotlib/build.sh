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
TERMUX_PKG_VERSION=(3.6.1)
TERMUX_PKG_VERSION+=(1.23.4) # NumPy version
TERMUX_PKG_VERSION+=(9.2.0)  # Pillow version
TERMUX_PKG_SRCURL=(https://github.com/matplotlib/matplotlib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/numpy/numpy/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz
                   https://github.com/python-pillow/Pillow/archive/refs/tags/${TERMUX_PKG_VERSION[2]}.tar.gz)
TERMUX_PKG_SHA256=(02163f7c2063c615b7fcb36c9b81b4293e567bdf7b6678ff80df914f16cf03a0
                   3ffd7b40ebe8a316324ff0cf83b820a25a034626836e001548d09d5b63ba84a8
                   95836f00972dbf724bf1270178683a0ac4ea23c6c3a980858fc9f2f9456e32ef)
TERMUX_PKG_DEPENDS="freetype, libc++, libjpeg-turbo, libtiff, libwebp, libxcb, littlecms, openjpeg, python, zlib"
_PKG_PYTHON_DEPENDS="'contourpy>=1.0.1' 'cycler>=0.10' 'fonttools>=4.22.0' 'kiwisolver>=1.0.1' 'numpy>=1.19' 'packaging>=20.0' 'pillow>=6.2.0' 'pyparsing>=2.2.1' 'python-dateutil>=2.7'"
TERMUX_PKG_BUILD_IN_SRC=true

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

TERMUX_PKG_RM_AFTER_INSTALL="
lib/python${_PYTHON_VERSION}/site-packages/__pycache__
lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
lib/python${_PYTHON_VERSION}/site-packages/site.py
"

termux_step_post_get_source() {
	mv numpy-${TERMUX_PKG_VERSION[1]} numpy
	mv Pillow-${TERMUX_PKG_VERSION[2]} Pillow
}

termux_step_pre_configure() {
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate

	build-pip install numpy setuptools_scm setuptools_scm_git_archive

	LDFLAGS+=" -lpython${_PYTHON_VERSION} -lm"

	export NPY_DISABLE_SVML=1
	pushd $TERMUX_PKG_SRCDIR/numpy
	MATHLIB="m" pip install .
	popd

	pushd $TERMUX_PKG_SRCDIR/Pillow
	INCLUDE=$TERMUX_PREFIX/include LIB=$TERMUX_PREFIX/lib \
		python setup.py install --force
	popd
}

termux_step_make_install() {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	pip install --no-deps . --prefix $TERMUX_PREFIX
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip. This may take a while..."
	MATHLIB="m" pip3 install ${_PKG_PYTHON_DEPENDS}
	EOF
}
