TERMUX_PKG_HOMEPAGE=https://github.com/krrishnarraj/libopencl-stub
TERMUX_PKG_DESCRIPTION="A stub opecl library that dynamically dlopen/dlsyms opencl implementations at runtime based on environment variables. Will be useful when opencl implementations are installed in non-standard paths"
TERMUX_PKG_VERSION=0.1
_COMMIT=8e3ccf116214685c210b5bb5235dd66ec0a61928
#_COMMIT=master
TERMUX_PKG_SRCURL="https://github.com/krrishnarraj/libopencl-stub/archive/${_COMMIT}.zip"
#TERMUX_PKG_SRCURL="https://github.com/rnauber/libopencl-stub/archive/${_COMMIT}.zip"
TERMUX_PKG_FOLDERNAME=libopencl-stub-${_COMMIT}
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="CC=$TERMUX_HOST_PLATFORM-clang RANLIB=$TERMUX_HOST_PLATFORM-ranlib"

termux_step_pre_configure() {       
        cp $TERMUX_PKG_BUILDER_DIR/libopencl.c $TERMUX_PKG_SRCDIR/src
}

termux_step_make_install () {	
	cp -r ./include/* $TERMUX_PREFIX/include
	cp  libOpenCL.a $TERMUX_PREFIX/lib/
}