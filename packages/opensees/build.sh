TERMUX_PKG_HOMEPAGE=https://opensees.berkeley.edu/
TERMUX_PKG_DESCRIPTION="Open System for Earthquake Engineering Simulation"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="Daniel <danielpdiamon@gmail.com>"
TERMUX_PKG_VERSION="3.8.0"
TERMUX_PKG_SRCURL="https://github.com/OpenSees/OpenSees/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="395d89f97ad0fe2a857e31b045c96badf23ad19ba8ce38f21c5a5d7891091810"
TERMUX_PKG_DEPENDS="eigen, libandroid-complex-math, libhdf5, libopenblas, tcl, zlib"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DOPS_FINAL_TARGET=OpenSees
-DTCL_INCLUDE_PATH=$TERMUX_PREFIX/include
-DTCL_LIBRARY=$TERMUX_PREFIX/lib/libtcl8.6.so
-DLAPACK_LIBRARIES=$TERMUX_PREFIX/lib/libopenblas.so
-DLAPACK_FOUND=TRUE
-DEigen3_INCLUDE_DIR=$TERMUX_PREFIX/include/eigen3
-DEIGEN3_INCLUDE_DIR=$TERMUX_PREFIX/include/eigen3
-DHDF5_INCLUDE_DIR=$TERMUX_PREFIX/include
-DHDF5_LIBRARIES=$TERMUX_PREFIX/lib/libhdf5.so
-DHDF5_FOUND=TRUE
-DZLIB_INCLUDE_DIR=$TERMUX_PREFIX/include
-DZLIB_LIBRARY=$TERMUX_PREFIX/lib/libz.so
-DZLIB_FOUND=TRUE
"

termux_step_post_get_source() {
	# 1. Compatibility patch for Clang and Tcl 8.6
	find SRC DEVELOPER -name "OPS_Globals.h" -exec sed -i 's/typedef char TCL_Char;/typedef const char TCL_Char;/g' {} +
	find SRC DEVELOPER -name "OPS_Globals.h" -exec sed -i 's/#define TCL_Char char/#define TCL_Char const char/g' {} +

	# 2. Fix TCL_Char in TclReliabilityBuilder.cpp
	if [ -f "SRC/reliability/tcl/TclReliabilityBuilder.cpp" ]; then
		sed -i '1i #ifndef TCL_Char\n#define TCL_Char const char\n#endif' SRC/reliability/tcl/TclReliabilityBuilder.cpp
	fi

	# 3. Fix pointer signatures in Reliability Tcl commands
	find SRC/reliability/tcl -type f \( -name "*.h" -o -name "*.cpp" \) -exec sed -i 's/TCL_Char \*\*argv/const char \*\*argv/g' {} +
	find SRC/reliability/tcl -type f \( -name "*.h" -o -name "*.cpp" \) -exec sed -i 's/char \*\*argv/const char \*\*argv/g' {} +
	find SRC/reliability -type f \( -name "*.h" -o -name "*.cpp" \) -exec sed -i 's/TCL_Char \*fileName/const TCL_Char *fileName/g' {} +
	find SRC/reliability -type f \( -name "*.h" -o -name "*.cpp" \) -exec sed -i 's/TCL_Char \*arrayName/const TCL_Char *arrayName/g' {} +
}

termux_step_pre_configure() {
	termux_setup_flang
	LDFLAGS+=" -landroid-complex-math -lm"
}

termux_step_post_configure() {
	# Remove GCC-specific libquadmath which is absent on Android NDK / Clang
	find "$TERMUX_PKG_BUILDDIR" \( -name "link.txt" -o -name "build.make" \) -exec sed -i 's/-lquadmath//g' {} +
}
