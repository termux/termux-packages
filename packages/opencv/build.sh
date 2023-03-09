TERMUX_PKG_HOMEPAGE=https://opencv.org/
TERMUX_PKG_DESCRIPTION="Open Source Computer Vision Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.7.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/opencv/opencv/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8df0079cdbe179748a18d44731af62a245a45ebf5085223dc03133954c662973
TERMUX_PKG_DEPENDS="abseil-cpp, ffmpeg, libc++, libjpeg-turbo, libopenblas, libpng, libprotobuf, libtiff, libwebp, openjpeg, openjpeg-tools, zlib"
TERMUX_PKG_BUILD_DEPENDS="python-numpy-static"
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
-DWITH_GSTREAMER=OFF
-DWITH_OPENEXR=OFF
-DBUILD_PROTOBUF=OFF
-DPROTOBUF_UPDATE_FILES=ON
-DOPENCV_GENERATE_PKGCONFIG=ON
-DOPENCV_SKIP_CMAKE_CXX_STANDARD=ON
"

termux_step_pre_configure() {
	termux_setup_protobuf

	CXXFLAGS+=" -std=c++14"
	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
	LDFLAGS+=" -llog"

	find "$TERMUX_PKG_SRCDIR" -name CMakeLists.txt -o -name '*.cmake' | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DPYTHON_DEFAULT_EXECUTABLE=python
		-DPYTHON3_INCLUDE_PATH=$TERMUX_PREFIX/include/python${TERMUX_PYTHON_VERSION}
		-DPYTHON3_NUMPY_INCLUDE_DIRS=$TERMUX_PYTHON_HOME/site-packages/numpy/core/include
		"
}
