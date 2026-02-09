TERMUX_PKG_HOMEPAGE=https://github.com/Z3Prover/z3
TERMUX_PKG_DESCRIPTION="Z3 is a theorem prover from Microsoft Research"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.15.7"
TERMUX_PKG_SRCURL=https://github.com/Z3Prover/z3/archive/refs/tags/z3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6033d04ee4c4260f378cf351a2c17c97ef11f185127d3d4721eb9df3d6a8575a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	# FPMATH_ENABLED=False to workaround NDK r27 issues:
	# clang++: error: unsupported option '-msse' for target 'aarch64-linux-androideabi24'
	# clang++: error: unsupported option '-msse2' for target 'armv7a-androideabi24'
	# clang++: error: unsupported option '-msimd128' for target 'i686-linux-androideabi24'
	# clang++: error: unsupported option '-msimd128' for target 'x86_64-linux-androideabi24'
	CXX="$CXX" CC="$CC" FPMATH_ENABLED=False python3 scripts/mk_make.py --prefix=$TERMUX_PREFIX --build=$TERMUX_PKG_BUILDDIR
	if $TERMUX_ON_DEVICE_BUILD; then
		sed 's%../../../../../../../../%%g' -i Makefile
	else
		sed 's%../../../../../%%g' -i Makefile
	fi
}
