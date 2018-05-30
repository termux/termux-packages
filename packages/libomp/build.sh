TERMUX_PKG_HOMEPAGE=https://clang.llvm.org/
TERMUX_PKG_DESCRIPTION="Modular compiler and toolchain technologies library"
_PKG_MAJOR_VERSION=6.0
TERMUX_PKG_VERSION=${_PKG_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=7c0e050d5f7da3b057579fb3ea79ed7dc657c765011b402eb5bbe5663a7c38fc
TERMUX_PKG_SRCURL=http://releases.llvm.org/${TERMUX_PKG_VERSION}/openmp-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_NO_DEVELSPLIT=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/libgomp.a
lib/libiomp5.a
"
TERMUX_PKG_DEPENDS="libllvm"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
TERMUX_PKG_CONFLICTS="gcc, clang (<< 3.9.1-3)"
TERMUX_PKG_REPLACES=gcc
# See http://llvm.org/docs/CMake.html:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=`which python`
-DLIBOMP_ENABLE_SHARED=FALSE
-DOPENMP_ENABLE_LIBOMPTARGET=OFF
-DPERL_EXECUTABLE=$(which perl)
"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true


termux_step_pre_configure () {
	mkdir runtime/src/android
	cp $TERMUX_PKG_BUILDER_DIR/nl_types.h runtime/src/android
	cp $TERMUX_PKG_BUILDER_DIR/nltypes_stubs.cpp runtime/src/android
}
