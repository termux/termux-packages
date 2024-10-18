TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/vision
TERMUX_PKG_DESCRIPTION="Datasets, Transforms and Models specific to Computer Vision"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20.0
TERMUX_PKG_SRCURL=git+https://github.com/pytorch/vision
# ffmpeg
TERMUX_PKG_DEPENDS="libc++, python, python-numpy, python-pillow, python-pip, python-torch, libjpeg-turbo, libpng, zlib"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools"

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PYTHON_HOME}/site-packages/torch/include"
	CFLAGS+=" -I${TERMUX_PYTHON_HOME}/site-packages/torch/include/torch/csrc/api/include"
	CXXFLAGS+=" -DUSE_PYTHON"
	LDFLAGS+=" -ltorch_cpu -ltorch_python -lc10"

	# FIXME: Disable ffmpeg temporarily because torchvision doesn't support ffmpeg 6.
	export TORCHVISION_USE_FFMPEG=0
	export BUILD_VERSION=$TERMUX_PKG_VERSION
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	pip -v install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "echo 'Installing dependencies for $TERMUX_PKG_NAME...'" >> postinst
	echo "pip3 install torchvision" >> postinst
}
