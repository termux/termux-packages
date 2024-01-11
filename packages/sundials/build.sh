TERMUX_PKG_HOMEPAGE=https://computing.llnl.gov/projects/sundials
TERMUX_PKG_DESCRIPTION="SUite of Nonlinear and DIfferential/ALgebraic equation Solvers."
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION="6.7.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/LLNL/sundials/releases/download/v${TERMUX_PKG_VERSION}/sundials-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5f113a1564a9d2d98ff95249f4871a4c815a05dbb9b8866a82b13ab158c37adb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="suitesparse"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_ARKODE=ON
-DBUILD_CVODE=ON
-DBUILD_CVODES=ON
-DBUILD_IDA=ON
-DBUILD_IDAS=ON
-DBUILD_KINSOL=ON
-DBUILD_SHARED_LIBS=ON
-DBUILD_STATIC_LIBS=ON
-DBUILD_FORTRAN_MODULE_INTERFACE=OFF
-DENABLE_KLU=ON
-DKLU_INCLUDE_DIR=$TERMUX_PREFIX/include/suitesparse
-DKLU_LIBRARY_DIR=$TERMUX_PREFIX/lib
-DENABLE_OPENMP=ON
-DENABLE_PTHREAD=ON
-DEXAMPLES_INSTALL=OFF
"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"
TERMUX_PKG_RM_AFTER_INSTALL="examples/"

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libsundials_arkode.so.5
lib/libsundials_cvode.so.6
lib/libsundials_cvodes.so.6
lib/libsundials_generic.so.6
lib/libsundials_ida.so.6
lib/libsundials_idas.so.5
lib/libsundials_kinsol.so.6
lib/libsundials_nvecmanyvector.so.6
lib/libsundials_nvecopenmp.so.6
lib/libsundials_nvecpthreads.so.6
lib/libsundials_nvecserial.so.6
lib/libsundials_sunmatrixband.so.4
lib/libsundials_sunmatrixdense.so.4
lib/libsundials_sunmatrixsparse.so.4
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
