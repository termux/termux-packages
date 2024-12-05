TERMUX_PKG_HOMEPAGE=https://github.com/pytorch/audio
TERMUX_PKG_DESCRIPTION="Data manipulation and transformation for audio signal processing, powered by PyTorch"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_SRCURL=git+https://github.com/pytorch/audio
# FFMPEG
TERMUX_PKG_DEPENDS="libc++, python, python-pip, python-torch"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	export BUILD_VERSION=$TERMUX_PKG_VERSION
	# FIXME: The same as torchvision, upstream doesn't support ffmpeg 6.
	export USE_FFMPEG=0
	export TORCHAUDIO_CMAKE_PREFIX_PATH="$TERMUX_PYTHON_HOME/site-packages/torch;$TERMUX_PREFIX"
	export host_alias="$TERMUX_HOST_PLATFORM"
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	pip -v install --no-build-isolation --no-deps --prefix "$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
