TERMUX_PKG_HOMEPAGE=https://octave.org
TERMUX_PKG_DESCRIPTION="GNU Octave is a high-level language, primarily intended for numerical computations. (only CLI)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftpmirror.gnu.org/octave/octave-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=21417afb579105b035cac0bea09201522e384893ae90a781b8727efa32765807
TERMUX_PKG_DEPENDS="libandroid-complex-math, arpack-ng, bzip2, fftw, fontconfig, freetype, glpk, graphicsmagick, libcurl, libhdf5, libiconv, libopenblas, libsndfile, openssl, pcre2, portaudio, qhull, qrupdate-ng, rapidjson, readline, suitesparse, sundials, zlib"
TERMUX_PKG_BUILD_DEPENDS="gnuplot, less"
TERMUX_PKG_RECOMMENDS="gnuplot, less"
TERMUX_PKG_CONFLICTS="octave-x"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-x
--disable-java
--enable-link-all-dependencies
--disable-openmp
--with-blas=openblas
--with-openssl=yes
--with-libiconv-prefix=$TERMUX_PREFIX
--enable-fortran-calling-convention=f2c
ac_cv_header_glob_h=no
ac_cv_func_endpwent=no
ac_cv_func_getegid=no
ac_cv_func_geteuid=no
ac_cv_func_getgrent=no
ac_cv_func_getgrgid=no
ac_cv_func_getgrnam=no
ac_cv_func_getpwent=no
ac_cv_func_getpwnam=no
ac_cv_func_getpwnam_r=no
ac_cv_func_getpwuid=no
ac_cv_func_setgrent=no
ac_cv_func_setpwent=no
ac_cv_func_setpwuid=no
"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_post_get_source() {
	# Version guard
	local ver_e=${TERMUX_PKG_VERSION#*:}
	local ver_x=$(. $TERMUX_SCRIPTDIR/x11-packages/octave-x/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_e}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between octave and octave-x."
	fi
}

termux_step_pre_configure() {
	termux_setup_flang

	local flang_toolchain_dir="$(dirname $(dirname $(command -v flang-new)))"
	local flang_libs_dir="$flang_toolchain_dir/sysroot/usr/lib/$TERMUX_HOST_PLATFORM"

	export F77="$FC"
	export ac_cv_f77_libs=" $flang_libs_dir/libFortranRuntime.a $flang_libs_dir/libFortranDecimal.a"

	LDFLAGS+=" -Wl,-rpath,$TERMUX_PREFIX/lib/octave/$TERMUX_PKG_VERSION"
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	export LIBS="-landroid-complex-math"
}
