TERMUX_PKG_HOMEPAGE=https://matplotlib.org/
TERMUX_PKG_DESCRIPTION="A comprehensive library for creating static, animated, and interactive visualizations in Python"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="\
LICENSE/LICENSE
LICENSE/LICENSE_AMSFONTS
LICENSE/LICENSE_BAKOMA
LICENSE/LICENSE_CARLOGO
LICENSE/LICENSE_COLORBREWER
LICENSE/LICENSE_JSXTOOLS_RESIZE_OBSERVER
LICENSE/LICENSE_QHULL
LICENSE/LICENSE_QT4_EDITOR
LICENSE/LICENSE_SOLARIZED
LICENSE/LICENSE_STIX
LICENSE/LICENSE_YORICK"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(3.5.1)
TERMUX_PKG_VERSION+=(1.22.3) # NumPy version
TERMUX_PKG_VERSION+=(9.0.1)  # Pillow version
TERMUX_PKG_SRCURL=(https://github.com/matplotlib/matplotlib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/numpy/numpy/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz
                   https://github.com/python-pillow/Pillow/archive/refs/tags/${TERMUX_PKG_VERSION[2]}.tar.gz)
TERMUX_PKG_SHA256=(9683da9a0c84d1c42d1bf92ecf6e012d302406a38fd987e3dfbcb7b58b2eea2d
                   c8f3ec591e3f17b939220f2b9eabb4c5e2db330f8af62c0a3aeee8a4d1a6c0db
                   01305f0befb644ce7fe90aa0c87573b9163a21d0e65149e8166c24974d9d37d2)
TERMUX_PKG_DEPENDS="freetype, libc++, libjpeg-turbo, libtiff, libwebp, libxcb, littlecms, openjpeg, python, zlib"
_PKG_PYTHON_DEPENDS="'cycler>=0.10' 'fonttools>=4.22.0' 'kiwisolver<1.4.0,>=1.0.1' 'numpy>=1.17' 'packaging>=20.0' 'pillow>=6.2.0' 'pyparsing>=2.2.1' 'python-dateutil>=2.7'"
TERMUX_PKG_BUILD_IN_SRC=true

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
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

	pushd ${_CROSSENV_PREFIX}/build/lib/python${_PYTHON_VERSION}/site-packages
	patch --silent -p1 < $TERMUX_PKG_BUILDER_DIR/setuptools-44.1.1-no-bdist_wininst.diff || :
	popd

	build-pip install numpy

	LDFLAGS+=" -lpython${_PYTHON_VERSION}"

	export NPY_DISABLE_SVML=1
	pushd $TERMUX_PKG_SRCDIR/numpy
	pip install .
	popd

	pushd $TERMUX_PKG_SRCDIR/Pillow
	INCLUDE=$TERMUX_PREFIX/include LIB=$TERMUX_PREFIX/lib \
		python setup.py install --force
	popd

	python setup.py install --force
}

termux_step_make_install() {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	python setup.py install --force --prefix $TERMUX_PREFIX

	pushd $PYTHONPATH
	_MATPLOTLIB_EGGDIR=
	for f in matplotlib-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}-linux-*.egg; do
		if [ -d "$f" ]; then
			_MATPLOTLIB_EGGDIR="$f"
			break
		fi
	done
	test -n "${_MATPLOTLIB_EGGDIR}"
	popd
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip. This may take a while..."
	pip3 install ${_PKG_PYTHON_DEPENDS}
	echo "./${_MATPLOTLIB_EGGDIR}" >> $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	sed -i "/\.\/${_MATPLOTLIB_EGGDIR//./\\.}/d" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF
}
