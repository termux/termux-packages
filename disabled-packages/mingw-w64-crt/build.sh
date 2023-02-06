TERMUX_PKG_HOMEPAGE=https://www.mingw-w64.org/
TERMUX_PKG_DESCRIPTION="MinGW-w64 runtime"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.MinGW-w64/COPYING.MinGW-w64.txt, COPYING.MinGW-w64-runtime/COPYING.MinGW-w64-runtime.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(10.0.0)
TERMUX_PKG_VERSION+=(2.39)   # GNU Binutils version
TERMUX_PKG_VERSION+=(12.2.0) # GCC version
TERMUX_PKG_VERSION+=(4.1.0)  # GNU MPFR version
TERMUX_PKG_VERSION+=(1.2.1)  # GNU MPC version
TERMUX_PKG_SRCURL=(https://downloads.sourceforge.net/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${TERMUX_PKG_VERSION}.tar.bz2
                   https://ftp.gnu.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION[1]}.tar.xz
                   https://ftp.gnu.org/gnu/gcc/gcc-${TERMUX_PKG_VERSION[2]}/gcc-${TERMUX_PKG_VERSION[2]}.tar.xz
                   https://ftp.gnu.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION[3]}.tar.xz
                   https://ftp.gnu.org/gnu/mpc/mpc-${TERMUX_PKG_VERSION[4]}.tar.gz)
TERMUX_PKG_SHA256=(ba6b430aed72c63a3768531f6a3ffc2b0fde2c57a3b251450dcf489a894f0894
                   645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00
                   e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff
                   0c98a3f1732ff6ca4ea690552079da9c597872d30e96ec28414ee23c95558a7f
                   17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459)
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	mv binutils-${TERMUX_PKG_VERSION[1]} binutils
	mv gcc-${TERMUX_PKG_VERSION[2]} gcc
	mv mpfr-${TERMUX_PKG_VERSION[3]} mpfr
	mv mpc-${TERMUX_PKG_VERSION[4]} mpc
}

termux_step_host_build() {
	local _PREFIX_FOR_BUILD="${TERMUX_PKG_HOSTBUILD_DIR}/prefix"
	export PATH="${_PREFIX_FOR_BUILD}/bin:$PATH"

	export CFLAGS="-O2"
	export CXXFLAGS="-O2"

	mkdir -p mpfr
	pushd mpfr
	$TERMUX_PKG_SRCDIR/mpfr/configure \
		--prefix="${_PREFIX_FOR_BUILD}"
	make -j "${TERMUX_MAKE_PROCESSES}"
	make install
	popd # mpfr

	mkdir -p mpc
	pushd mpc
	$TERMUX_PKG_SRCDIR/mpc/configure \
		--prefix="${_PREFIX_FOR_BUILD}" \
		--with-mpfr="${_PREFIX_FOR_BUILD}"
	make -j "${TERMUX_MAKE_PROCESSES}"
	make install
	popd # mpc

	local arch
	for arch in x86_64 i686; do
		local target="${arch}-w64-mingw32"
		local sysroot="${TERMUX_PREFIX}/${target}"
		mkdir -p "${target}"
		pushd "${target}"

		mkdir -p binutils
		pushd binutils
		$TERMUX_PKG_SRCDIR/binutils/configure \
			--prefix="${_PREFIX_FOR_BUILD}" \
			--target="${target}"
		make -j "${TERMUX_MAKE_PROCESSES}"
		make install
		popd # binutils

		mkdir -p mingw-w64-headers
		pushd mingw-w64-headers
		$TERMUX_PKG_SRCDIR/configure \
			--prefix="${sysroot}/usr" \
			--without-crt
		make
		make install
		popd # mingw-w64-headers

		ln -sfT usr "${sysroot}/mingw"
		ln -sfT usr "${sysroot}/${target}"

		mkdir -p gcc-nocrt
		pushd gcc-nocrt
		$TERMUX_PKG_SRCDIR/gcc/configure \
			--prefix="${_PREFIX_FOR_BUILD}" \
			--target="${target}" \
			--with-sysroot="${sysroot}" \
			--disable-multilib \
			--with-mpfr="${_PREFIX_FOR_BUILD}" \
			--with-mpc="${_PREFIX_FOR_BUILD}" \
			--enable-languages=c \
			--disable-libatomic \
			--disable-libquadmath \
			--disable-libssp \
			--disable-shared
		make -j "${TERMUX_MAKE_PROCESSES}"
		make install
		popd # gcc-nocrt

		mkdir -p mingw-w64-crt
		pushd mingw-w64-crt
		local mingw_crt_conf
		case "${arch}" in
			i686 )
				mingw_crt_conf="--enable-lib32 --disable-lib64"
				;;
			x86_64 )
				mingw_crt_conf="--enable-lib64 --disable-lib32"
				;;
		esac
		$TERMUX_PKG_SRCDIR/configure \
			--prefix="${sysroot}/usr" \
			--host="${target}" \
			${mingw_crt_conf}
		make -j "${TERMUX_MAKE_PROCESSES}"
		make -C mingw-w64-crt install
		popd # mingw-w64-crt

		popd # "${target}"
	done
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	:
}
