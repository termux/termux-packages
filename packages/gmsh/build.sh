TERMUX_PKG_HOMEPAGE=https://gmsh.info/
TERMUX_PKG_DESCRIPTION="Three-dimensional finite element mesh generator"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@Danielk10"
_COMMIT=c020e8f438f8a6dfc674f440ded2030f59d8d502
TERMUX_PKG_VERSION="5.0.0"
TERMUX_PKG_SRCURL="git+https://gitlab.onelab.info/gmsh/gmsh.git"
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, libhdf5, libopenblas, zlib"
TERMUX_PKG_SUGGESTS="medfile, opencascade"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_BUILD_DYNAMIC=ON
-DENABLE_BUILD_SHARED=ON
-DENABLE_FLTK=OFF
-DENABLE_OPENGL=OFF
-DENABLE_MPI=OFF
-DENABLE_VTK=OFF
-DENABLE_BLAS_LAPACK=ON
-DBLAS_LIBRARIES=$TERMUX_PREFIX/lib/libopenblas.so
-DLAPACK_LIBRARIES=$TERMUX_PREFIX/lib/libopenblas.so
-DHDF5_ROOT=$TERMUX_PREFIX
-DCASROOT=$TERMUX_PREFIX
-DMED3HOME=$TERMUX_PREFIX
"

termux_step_post_get_source() {
	git checkout $_COMMIT
}

termux_step_post_massage() {
	local _SOVERSION_GUARD_FILES="
lib/libgmsh.so.5.0
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
