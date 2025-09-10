TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/vision
TERMUX_PKG_DESCRIPTION="Datasets, Transforms and Models specific to Computer Vision"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.21.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/pytorch/vision/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0a4a967bbb7f9810f792cd0289a07fb98c8fb5d1303fae8b63e3a6b05d720058
TERMUX_PKG_DEPENDS="libc++, ffmpeg, python, python-numpy, python-pillow, python-pip, python-torch, libjpeg-turbo, libpng, libwebp, zlib"
TERMUX_PKG_SETUP_PYTHON=true

termux_step_pre_configure() {
	CXXFLAGS+=" -I${TERMUX_PYTHON_HOME}/site-packages/torch/include"
	CXXFLAGS+=" -I${TERMUX_PYTHON_HOME}/site-packages/torch/include/torch/csrc/api/include"
	CXXFLAGS+=" -DUSE_PYTHON"
	LDFLAGS+=" -ltorch_cpu -ltorch_python -lc10"

	# setting this $BUILD_PREFIX variable, which wasn't previously set, causes
	# libwebp to be detected and libjpeg to be detected,
	# and assists with detecting ffmpeg
	export BUILD_PREFIX="$TERMUX_PREFIX"
	export BUILD_VERSION=$TERMUX_PKG_VERSION

	# this causes ffmpeg to be detected during cross-compilation,
	# enabling the "video decoder extensions"
	sed -i "s|shutil.which(\"ffmpeg\")|\"$TERMUX_PREFIX/bin/ffmpeg\"|" setup.py
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
