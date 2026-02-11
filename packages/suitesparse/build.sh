TERMUX_PKG_HOMEPAGE=https://github.com/DrTimothyAldenDavis/SuiteSparse
TERMUX_PKG_DESCRIPTION="A Suite of Sparse matrix packages."
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:7.12.2"
TERMUX_PKG_SRCURL=https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=679412daa5f69af96d6976595c1ac64f252287a56e98cc4a8155d09cc7fd69e8
TERMUX_PKG_DEPENDS="libandroid-complex-math, libgmp, libmpfr, libopenblas"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="sundials (<< 7.1.1-2), octave (<< 8.4.0-6), octave-x (<< 8.4.0-5)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBLA_VENDOR=OpenBLAS
-DALLOW_64BIT_BLAS=OFF
-DGRAPHBLAS_CROSS_TOOLCHAIN_FLAGS_NATIVE=\"-DCMAKE_TOOLCHAIN_FILE=$TERMUX_PKG_BUILDER_DIR/graphblas-host-toolchain.cmake\"
"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_flang

	LDFLAGS+=" -fopenmp -static-openmp -landroid-complex-math -lm"
}

termux_step_make() {
	# Follow termux_step_configure_cmake
	MAKE_PROGRAM_PATH=$(command -v make)
	BUILD_TYPE=Release
	test "$TERMUX_DEBUG_BUILD" == "true" && BUILD_TYPE=Debug
	CMAKE_PROC=$TERMUX_ARCH
	test $CMAKE_PROC == "arm" && CMAKE_PROC='armv7-a'

	local CMAKE_OPTIONS=
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
		CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
		LDFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"

		CMAKE_OPTIONS+=" -DCMAKE_CROSSCOMPILING=True"
		CMAKE_OPTIONS+=" -DCMAKE_LINKER=\"$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD $LDFLAGS\""
		CMAKE_OPTIONS+=" -DCMAKE_SYSTEM_NAME=Android"
		CMAKE_OPTIONS+=" -DCMAKE_SYSTEM_VERSION=$TERMUX_PKG_API_LEVEL"
		CMAKE_OPTIONS+=" -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_PROC"
		CMAKE_OPTIONS+=" -DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=$TERMUX_STANDALONE_TOOLCHAIN"
	else
		CMAKE_OPTIONS+=" -DCMAKE_LINKER=\"$(command -v $LD) $LDFLAGS\""
	fi

	CMAKE_OPTIONS+=" -DCMAKE_AR=\"$(command -v $AR)\""
	CMAKE_OPTIONS+=" -DCMAKE_UNAME=\"$(command -v uname)\""
	CMAKE_OPTIONS+=" -DCMAKE_RANLIB=\"$(command -v $RANLIB)\""
	CMAKE_OPTIONS+=" -DCMAKE_STRIP=\"$(command -v $STRIP)\""
	CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE=$BUILD_TYPE"
	CMAKE_OPTIONS+=" -DCMAKE_C_FLAGS=\"$CFLAGS $CPPFLAGS\""
	CMAKE_OPTIONS+=" -DCMAKE_CXX_FLAGS=\"$CXXFLAGS $CPPFLAGS\""
	CMAKE_OPTIONS+=" -DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX"
	CMAKE_OPTIONS+=" -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER"
	CMAKE_OPTIONS+=" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=NEVER"
	CMAKE_OPTIONS+=" -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=NEVER"
	CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX"
	CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR=$TERMUX_PREFIX/lib"
	CMAKE_OPTIONS+=" -DCMAKE_MAKE_PROGRAM=$MAKE_PROGRAM_PATH"
	CMAKE_OPTIONS+=" -DCMAKE_SKIP_INSTALL_RPATH=ON"
	CMAKE_OPTIONS+=" -DCMAKE_USE_SYSTEM_LIBRARIES=True"
	CMAKE_OPTIONS+=" -DDOXYGEN_EXECUTABLE="
	CMAKE_OPTIONS+=" -DBUILD_TESTING=OFF"
	CMAKE_OPTIONS+=" $(echo $TERMUX_PKG_EXTRA_CONFIGURE_ARGS)"

	make -j $TERMUX_PKG_MAKE_PROCESSES \
		CMAKE_OPTIONS="$CMAKE_OPTIONS" JOBS=$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	make install INSTALL=$TERMUX_PREFIX
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	# local _SOVERSION_GUARD_FILES=$(find lib/ | grep -E '\.so\.[0-9]+$' | sort)
	local _SOVERSION_GUARD_FILES="
lib/libamd.so.3
lib/libbtf.so.2
lib/libcamd.so.3
lib/libccolamd.so.3
lib/libcholmod.so.5
lib/libcolamd.so.3
lib/libcxsparse.so.4
lib/libgraphblas.so.10
lib/libklu_cholmod.so.2
lib/libklu.so.2
lib/liblagraph.so.1
lib/liblagraphx.so.1
lib/libldl.so.3
lib/libparu.so.1
lib/librbio.so.4
lib/libspexpython.so.3
lib/libspex.so.3
lib/libspqr.so.4
lib/libsuitesparseconfig.so.7
lib/libsuitesparse_mongoose.so.3
lib/libumfpack.so.6
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
