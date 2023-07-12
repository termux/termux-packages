TERMUX_PKG_HOMEPAGE=https://opencv.org/
TERMUX_PKG_DESCRIPTION="Open Source Computer Vision Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.8.0
TERMUX_PKG_SRCURL=https://github.com/opencv/opencv/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cbf47ecc336d2bff36b0dcd7d6c179a9bb59e805136af6b9670ca944aef889bd
TERMUX_PKG_DEPENDS="abseil-cpp, ffmpeg, libc++, libjpeg-turbo, libopenblas, libpng, libtiff, libwebp, openjpeg, openjpeg-tools, zlib"
# For static libprotobuf see
# https://github.com/termux/termux-packages/issues/16979
TERMUX_PKG_BUILD_DEPENDS="libutf8-range, protobuf-static, python-numpy-static"
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
	LDFLAGS+=" -lutf8_range -lutf8_validity"
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

	mv $TERMUX_PREFIX/lib/libprotobuf.so{,.tmp}
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/libprotobuf.so{.tmp,}
}

termux_step_post_massage() {
	rm -f lib/libprotobuf.so
}
