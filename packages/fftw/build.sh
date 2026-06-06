TERMUX_PKG_HOMEPAGE=http://www.fftw.org/
TERMUX_PKG_DESCRIPTION="Library for computing the Discrete Fourier Transform (DFT) in one or more dimensions"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.10
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://www.fftw.org/fftw-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467
# TERMUX_PKG_DEPENDS="openmpi"
TERMUX_PKG_BREAKS="fftw-dev"
TERMUX_PKG_REPLACES="fftw-dev"
TERMUX_PKG_RM_AFTER_INSTALL="include/fftw*.f*"

# The rest of this build script is in large part a port of Arch Linux's fftw PKGBUILD.
# https://gitlab.archlinux.org/archlinux/packaging/packages/fftw/-/blob/3.3.10-8/PKGBUILD

termux_step_pre_configure() {
	# what targets are we building?
	declare -ga build_targets=("single" "double" "long-double")
	local _SOVERSION=3.6.10 target
	# The SOVERSION is wrong in the CMakeLists.txt for 3.3.10
	sed -e "s/3.6.9/$_SOVERSION/" -i "$TERMUX_PKG_SRCDIR/CMakeLists.txt"
	# Make a clean copy of the build directory for each target
	for target in "${build_targets[@]}"; do
		cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}-${target}"
		echo "created directory '${TERMUX_PKG_BUILDDIR}-${target}'"
	done
	# We can then get rid of the original one
	rm -vrf "${TERMUX_PKG_BUILDDIR}"

	# Update the TERMUX_PKG_BUILDDIR to point at the TERMUX_PKG_SRCDIR,
	# otherwise it points at a nonexistent directory which will cause
	# `cd $TERMUX_PKG_BUILDDIR` commands to fail between later build steps
	export ORIG_TERMUX_PKG_BUILDDIR="$TERMUX_PKG_BUILDDIR"
	export TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
}

termux_step_configure() {
	termux_setup_cmake
	termux_setup_flang

	local target
	local -a _CONFIGURE_COMMON=(
		"--enable-threads"
		"--enable-openmp"
			# "--enable-mpi"
			# MPILIBS="$(mpicc --showme:link)"
		# ac_cv_func_clock_gettime=no avoids having clock_gettime(CLOCK_SGI_CYCLE, &t)
		# being used. It's not supported on Android but fails at runtime and, fftw
		# does not check the return value so gets bogus values.
		"ac_cv_func_clock_gettime=no"
	)
	local -a _CONFIGURE_SINGLE=( "--enable-single" )
	local -a _CONFIGURE_DOUBLE=() # no applicable extra args for us
	local -a _CONFIGURE_LONG_DOUBLE=( "--enable-long-double" )
	local -a _CMAKE_ARGS=(
		"-Bbuild"
		"-S${ORIG_TERMUX_PKG_BUILDDIR}-single"
		"-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX"
		"-DCMAKE_BUILD_TYPE=None"
		"-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
		"-DENABLE_OPENMP=ON"
		"-DENABLE_THREADS=ON"
		"-DENABLE_FLOAT=ON"
		"-DENABLE_LONG_DOUBLE=ON"
		"-DENABLE_QUAD_PRECISION=ON"
	)

	# create missing FFTW3LibraryDepends.cmake
	# https://bugs.archlinux.org/task/67604
	cmake "${_CMAKE_ARGS[@]}"
	# fix broken IMPORTED_LOCATION: https://github.com/FFTW/fftw3/issues/130#issuecomment-1030280157
	sed -e 's|\(IMPORTED_LOCATION_NONE\).*|\1 "/usr/lib/libfftw3.so.3"|' -i build/FFTW3LibraryDepends.cmake

	export F77="$FC"
	# use upstream default CFLAGS
	CFLAGS+=" -O3 -fomit-frame-pointer -malign-double -fstrict-aliasing -ffast-math"

	for target in "${build_targets[@]}"; do
		( # Configure each target's build directory with the appropriate build flags
			cd "${ORIG_TERMUX_PKG_BUILDDIR}-${target}" && \
			local -a _args=("${_CONFIGURE_COMMON[@]}")
			case "$target" in
				'single')      _args+=("${_CONFIGURE_SINGLE[@]}");;
				'double')      _args+=("${_CONFIGURE_DOUBLE[@]}");;
				'long-double') _args+=("${_CONFIGURE_LONG_DOUBLE[@]}");;
				'quad')        _args+=("${_CONFIGURE_QUAD[@]}");;
			esac
			TERMUX_PKG_EXTRA_CONFIGURE_ARGS="${_args[*]} V=1" \
			termux_step_configure_autotools

			# fix overlinking because of libtool
			sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
		)
	printf '\e[31mAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH\e[m\n'
	done
}

termux_step_make(){
	local target
	for target in "${build_targets[@]}"; do
		make --directory "${ORIG_TERMUX_PKG_BUILDDIR}-${target}"
	done
}

# termux_step_make_install(){
# 	: # ports for the port god, builds for the build throne
# }
