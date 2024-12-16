TERMUX_PKG_HOMEPAGE=https://opencv.org/
TERMUX_PKG_DESCRIPTION="Open Source Computer Vision Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.10.0"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=(
	https://github.com/opencv/opencv/archive/${TERMUX_PKG_VERSION}/opencv-${TERMUX_PKG_VERSION}.tar.gz
	https://github.com/opencv/opencv_contrib/archive/${TERMUX_PKG_VERSION}/opencv_contrib-${TERMUX_PKG_VERSION}.tar.gz
)
TERMUX_PKG_SHA256=(
	b2171af5be6b26f7a06b1229948bbb2bdaa74fcf5cd097e0af6378fce50a6eb9
	65597f8fb8dc2b876c1b45b928bbcc5f772ddbaf97539bf1b737623d0604cba1
)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, ffmpeg, libc++, libjpeg-turbo, libopenblas, libpng, libtiff, libwebp, openjpeg, openjpeg-tools, qt6-qtbase, qt6-qt5compat, zlib"
# For static libprotobuf see
# https://github.com/termux/termux-packages/issues/16979
TERMUX_PKG_BUILD_DEPENDS="libutf8-range, protobuf-static, python-numpy-static"
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
-DWITH_GSTREAMER=OFF
-DWITH_OPENEXR=OFF
-DWITH_QT=6
-DBUILD_PERF_TESTS=OFF
-DBUILD_PROTOBUF=OFF
-DBUILD_TESTS=OFF
-DPROTOBUF_UPDATE_FILES=ON
-DOPENCV_EXTRA_MODULES_PATH=$TERMUX_PKG_SRCDIR/opencv_contrib-$TERMUX_PKG_VERSION/modules \
-DOPENCV_GENERATE_PKGCONFIG=ON
-DOPENCV_SKIP_CMAKE_CXX_STANDARD=ON
"

termux_step_pre_configure() {
	termux_setup_protobuf
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DProtobuf_PROTOC_EXECUTABLE=$(command -v protoc)"
	sed -i 's/COMMAND\sprotobuf::protoc/COMMAND ${Protobuf_PROTOC_EXECUTABLE}/g' $TERMUX_PREFIX/lib/cmake/protobuf/protobuf-generate.cmake

	# Keep this the same version which abseil-cpp requires
	CXXFLAGS+=" -std=c++17"
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
		-DPYTHON3_NUMPY_INCLUDE_DIRS=$TERMUX_PYTHON_HOME/site-packages/numpy/_core/include
		"

	mv $TERMUX_PREFIX/lib/libprotobuf.so{,.tmp}
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/libprotobuf.so{.tmp,}
}

termux_step_post_massage() {
	rm -rf lib/libprotobuf.so lib/cmake/protobuf/
}
