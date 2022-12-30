TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/vision
TERMUX_PKG_DESCRIPTION="Datasets, Transforms and Models specific to Computer Vision"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.13.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/pytorch/vision
TERMUX_PKG_DEPENDS="python, python-numpy, python-pillow, python-torch, libjpeg-turbo, libpng, ffmpeg, zlib"

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

	build-pip install -U wheel setuptools

	CFLAGS+=" -I${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/torch/include"
	CFLAGS+=" -I${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/torch/include/torch/csrc/api/include"
	CXXFLAGS+=" -DUSE_PYTHON"
	LDFLAGS+=" -ltorch_cpu -ltorch_python -lc10"
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	pip -v install --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip3 install typing_extensions requests" >> postinst
}
