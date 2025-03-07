TERMUX_PKG_HOMEPAGE=https://octave.org
TERMUX_PKG_DESCRIPTION="GNU Octave is a high-level language, primarily intended for numerical computations"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftpmirror.gnu.org/octave/octave-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fff911909ef79f95ba244dab5b8c1cb8c693a6c447d31deabb53994f17cb7b3d
TERMUX_PKG_DEPENDS="arpack-ng, clang, fftw, fltk, fontconfig, freetype, glpk, glu, graphicsmagick, libandroid-complex-math, libbz2, libc++, libcurl, libhdf5, libiconv, libopenblas, libsndfile, libx11, libxcursor, libxext, libxfixes, libxft, libxinerama, libxrender, make, opengl, openssl, pcre2, portaudio, qhull, qrupdate-ng, qt6-qt5compat, qt6-qtbase, qt6-qttools, readline, suitesparse, sundials, zlib"
TERMUX_PKG_BUILD_DEPENDS="gnuplot, less, rapidjson, qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_RECOMMENDS="gnuplot, less"
TERMUX_PKG_CONFLICTS="octave-x"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-x
--with-qt=6
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
	local ver_x=$(. $TERMUX_SCRIPTDIR/packages/octave/build.sh; echo ${TERMUX_PKG_VERSION#*:})
	if [ "${ver_e}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between octave and octave-x."
	fi
}

termux_step_pre_configure() {
	termux_setup_flang

	local flang_toolchain_dir="$(dirname $(dirname $(command -v flang-new)))"
	local flang_libs_dir="$flang_toolchain_dir/sysroot/usr/lib/$TERMUX_HOST_PLATFORM"

	export F77="$FC"
	mkdir -p $TERMUX_PKG_TMPDIR/_deps
	ln -sf $flang_libs_dir/libFortranRuntime.a $TERMUX_PKG_TMPDIR/_deps/
	ln -sf $flang_libs_dir/libFortranDecimal.a $TERMUX_PKG_TMPDIR/_deps/
	export ac_cv_f77_libs="-L$TERMUX_PKG_TMPDIR/_deps -l:libFortranRuntime.a -l:libFortranDecimal.a"

	LDFLAGS+=" -Wl,-rpath,$TERMUX_PREFIX/lib/octave/$TERMUX_PKG_VERSION"
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	# put -l:$_libgcc_name only in $LIBS instead of $LDFLAGS
	export LIBS="-landroid-complex-math -L$_libgcc_path -l:$_libgcc_name"

	export PATH="$TERMUX_PREFIX/opt/qt6/cross/bin:$PATH"
}
