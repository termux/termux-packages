TERMUX_PKG_HOMEPAGE=https://www.tensorflow.org/lite
TERMUX_PKG_DESCRIPTION="TensorFlow Lite Python bindings"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.20.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/tensorflow/tensorflow
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python, python-numpy, python-pip"
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools, wheel, pybind11"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DTFLITE_HOST_TOOLS_DIR=$TERMUX_PKG_HOSTBUILD_DIR
"

termux_step_host_build() {
	termux_setup_cmake

	cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 "$TERMUX_PKG_SRCDIR"/tensorflow/lite
	cmake --build . --verbose -j $TERMUX_PKG_MAKE_PROCESSES -t flatbuffers-flatc
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja

	# Copied from tensorflow/lite/tools/pip_package/build_pip_package_with_cmake.sh
	export TENSORFLOW_DIR="$TERMUX_PKG_SRCDIR"
	local TENSORFLOW_LITE_DIR="$TENSORFLOW_DIR/tensorflow/lite"
	local TENSORFLOW_VERSION=$(grep "TF_VERSION = " "${TENSORFLOW_DIR}/tensorflow/tf_version.bzl" | cut -d= -f2 | sed 's/[ "-]//g')
	IFS='.' read -r -a array <<< "$TENSORFLOW_VERSION"
	local TF_MAJOR=${array[0]}
	local TF_MINOR=${array[1]}
	local TF_PATCH=${array[2]}
	local TF_CXX_FLAGS="-DTF_MAJOR_VERSION=${TF_MAJOR} -DTF_MINOR_VERSION=${TF_MINOR} -DTF_PATCH_VERSION=${TF_PATCH} -DTF_VERSION_SUFFIX=''"
	export PACKAGE_VERSION="$TENSORFLOW_VERSION"
	export PROJECT_NAME="tflite_runtime"
	TFLITE_BUILD_DIR="$TERMUX_PKG_BUILDDIR/build-wheel"
	local BUILD_DIR="$TFLITE_BUILD_DIR"
	local PYTHON="$(command -v python)"
	local PYBIND11_INCLUDE=$($PYTHON -c "import pybind11; print (pybind11.get_include())")
	CPPFLAGS+=" -I$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include"
	CPPFLAGS+=" -I$PYBIND11_INCLUDE"
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION"
	CPPFLAGS+=" $TF_CXX_FLAGS"

	# Build source tree
	rm -rf "$BUILD_DIR" && mkdir -p "$BUILD_DIR/tflite_runtime"
	cp -r "$TENSORFLOW_LITE_DIR/tools/pip_package/debian" \
		"$TENSORFLOW_LITE_DIR/tools/pip_package/MANIFEST.in" \
		"$TENSORFLOW_LITE_DIR/python/interpreter_wrapper" \
		"$BUILD_DIR"
	cp  "$TENSORFLOW_LITE_DIR/tools/pip_package/setup_with_binary.py" "$BUILD_DIR/setup.py"
	cp "$TENSORFLOW_LITE_DIR/python/interpreter.py" \
		"$TENSORFLOW_LITE_DIR/python/metrics/metrics_interface.py" \
		"$TENSORFLOW_LITE_DIR/python/metrics/metrics_portable.py" \
		"$BUILD_DIR/tflite_runtime"
	echo "__version__ = '$PACKAGE_VERSION'" >> "$BUILD_DIR/tflite_runtime/__init__.py"
	echo "__git_version__ = '$(git -C "$TENSORFLOW_DIR" describe)'" >> "$BUILD_DIR/tflite_runtime/__init__.py"

	TERMUX_PKG_SRCDIR_OLD="$TERMUX_PKG_SRCDIR"
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/tensorflow/lite"
}

termux_step_post_configure() {
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR_OLD"
}

termux_step_make() {
	# Build python interpreter_wrapper
	cmake --build . -j $TERMUX_PKG_MAKE_PROCESSES -t _pywrap_tensorflow_interpreter_wrapper
	cp "$TERMUX_PKG_BUILDDIR/_pywrap_tensorflow_interpreter_wrapper.so" \
		"$TFLITE_BUILD_DIR/tflite_runtime"

	# Build python wheel
	cd "$TFLITE_BUILD_DIR"
	python setup.py bdist_wheel
}

termux_step_make_install() {
	local _pyver="${TERMUX_PYTHON_VERSION//./}"
	local _wheel="tflite_runtime-${TERMUX_PKG_VERSION}-cp${_pyver}-cp${_pyver}-linux_${TERMUX_ARCH}.whl"
	pip install --force-reinstall --no-deps --prefix="$TERMUX_PREFIX" "$TFLITE_BUILD_DIR/dist/${_wheel}"
}
