TERMUX_PKG_HOMEPAGE=https://pytorch.org/
TERMUX_PKG_DESCRIPTION="Tensors and Dynamic neural networks in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.12.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/pytorch/pytorch
TERMUX_PKG_DEPENDS="python, python-numpy, libopenblas, libprotobuf, libzmq, ffmpeg, opencv"
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_RM_AFTER_INSTALL="lib/pkgconfig/sleef.pc"

termux_step_post_get_source() {
	termux_setup_cmake
}

termux_step_host_build() {
	cmake "$TERMUX_PKG_SRCDIR/third_party/sleef"
	make -j "$TERMUX_MAKE_PROCESSES" mkrename mkrename_gnuabi mkmasked_gnuabi mkalias mkdisp
}

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_python_crossenv
		pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
		_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
		python${_PYTHON_VERSION} -m crossenv \
			$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
			${_CROSSENV_PREFIX}
		popd
		. ${_CROSSENV_PREFIX}/bin/activate

		build-pip install -U wheel pyyaml numpy typing_extensions
	fi
	
	pip install -U typing_extensions
	
	termux_setup_protobuf

	find "$TERMUX_PKG_SRCDIR" -name CMakeLists.txt -o -name '*.cmake' | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'

	LDFLAGS+=" -llog -lpython${_PYTHON_VERSION}"
	
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-DBUILD_PYTHON=ON
	-DBUILD_TEST=OFF
	-DCMAKE_BUILD_TYPE=Release
	-DCMAKE_INSTALL_PREFIX=${TERMUX_PKG_SRCDIR}/torch
	-DCMAKE_PREFIX_PATH=${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages
	-DNUMPY_INCLUDE_DIR=${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages/numpy/core/include
	-DPYTHON_EXECUTABLE=$(command -v python3)
	-DPYTHON_INCLUDE_DIR=${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}
	-DPYTHON_LIBRARY=${TERMUX_PREFIX}/lib//libpython${_PYTHON_VERSION}.so
	-DTORCH_BUILD_VERSION=${TERMUX_PKG_VERSION}
	-DUSE_NUMPY=ON
	-DUSE_OPENCV=ON
	-DUSE_FFMPEG=ON
	-DUSE_ZMQ=ON
	-DANDROID_NO_TERMUX=OFF
	-DOpenBLAS_INCLUDE_DIR=${TERMUX_PREFIX}/include/openblas
	-DNATIVE_BUILD_DIR=${TERMUX_PKG_HOSTBUILD_DIR}
	-DBUILD_CUSTOM_PROTOBUF=OFF
	-DPROTOBUF_PROTOC_EXECUTABLE=$(command -v protoc)	
	-DCAFFE2_CUSTOM_PROTOC_EXECUTABLE=$(command -v protoc)
	-DCXX_AVX512_FOUND=OFF
	-DCXX_AVX2_FOUND=OFF
	"
	
	# to build x86_64 version anyway
	# /home/builder/.termux-build/python-torch/src/third_party/fbgemm/third_party/asmjit/src/asmjit/core/../core/operand.h:910:79: error: use of bitwise '&' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DCAFFE2_COMPILER_SUPPORTS_AVX512_EXTENSIONS=OFF
	"
	# /home/builder/.termux-build/python-torch/src/torch/csrc/jit/codegen/onednn/graph_helper.h:3:10: fatal error: 'oneapi/dnnl/dnnl_graph.hpp' file not found
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-DUSE_MKLDNN=OFF
	"
	
	# /home/builder/.termux-build/_cache/android-r25b-api-24-v0/sysroot/usr/include/linux/types.h:21:10: fatal error: 'asm/types.h' file not found
	ln -s ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/${TERMUX_ARCH}-linux-android$( if test $TERMUX_ARCH = arm; then echo eabi; fi )/asm
	
	ln -s "$TERMUX_PKG_BUILDDIR" build
}

termux_step_make_install() {
	pip -v install --prefix $TERMUX_PREFIX "$TERMUX_PKG_SRCDIR"
	ln -s ${TERMUX_PREFIX}/lib/python3.10/site-packages/torch/lib/*.so ${TERMUX_PREFIX}/lib
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip3 install typing_extensions" >> postinst
}
