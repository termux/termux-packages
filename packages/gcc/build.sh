TERMUX_PKG_HOMEPAGE=https://gcc.gnu.org/
TERMUX_PKG_DESCRIPTION="GNU C, C++ and Fortran compilers"
TERMUX_PKG_LICENSE="GPL-3.0-or-later, LGPL-3.0-or-later"
TERMUX_PKG_LICENSE_FILE="COPYING3, COPYING3.LIB, COPYING.RUNTIME"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="16.2.0"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gcc/gcc-${TERMUX_PKG_VERSION}/gcc-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e
TERMUX_PKG_DEPENDS="binutils, libc++, libgmp, libisl, libmpc, libmpfr, ndk-sysroot, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="binutils-cross"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-initfini-array
--enable-default-pie
--enable-languages=c,c++,fortran
--enable-lto
--enable-host-shared
--enable-host-libquadmath
--enable-libatomic
--enable-libatomic-ifuncs=no
--enable-libbacktrace
--enable-libquadmath
--enable-libgomp
--enable-gold
--enable-version-specific-runtime-libs
--enable-eh-frame-hdr-for-static
--disable-bootstrap
--disable-nls
--disable-shared
--disable-libssp
--disable-libstdcxx
--disable-multilib
--disable-tls
--with-ld=$TERMUX_PREFIX/bin/ld.bfd
--with-build-time-tools=$TERMUX_PREFIX/opt/binutils/cross/$TERMUX_HOST_PLATFORM/bin
--with-libatomic
--with-system-zlib
--with-zstd=$TERMUX_PREFIX
--with-gmp=$TERMUX_PREFIX
--with-mpfr=$TERMUX_PREFIX
--with-mpc=$TERMUX_PREFIX
--with-isl=$TERMUX_PREFIX
--with-gxx-include-dir=$TERMUX_PREFIX/include/c++/v1
--program-suffix=-${TERMUX_PKG_VERSION%%.*}
--target=$TERMUX_HOST_PLATFORM
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/info
share/man/man7
"

_ARCH_ARGS=""
_ARCH_SPECS=""
case "$TERMUX_ARCH" in
	arm)
		_ARCH_ARGS="--with-arch=armv7-a --with-float=soft --with-fpu=vfp"
		;;
	aarch64)
		_ARCH_ARGS="--enable-fix-cortex-a53-835769 --enable-fix-cortex-a53-843419"
		_ARCH_SPECS="\n*cc1:\n+ -ffixed-x18\n\n*cc1plus:\n+ -ffixed-x18\n"
		;;
	i686)
		_ARCH_ARGS="--with-arch=i686 --with-fpmath=sse"
		_ARCH_SPECS="\n*link_emulation:\nelf_i386\n\n*dynamic_linker:\n/system/bin/linker\n"
		;;
	x86_64)
		_ARCH_ARGS="--with-arch=x86-64 --with-fpmath=sse"
		;;
esac
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" $_ARCH_ARGS"

# Compat headers are installed here and put first in the specs.
_COMPAT_DIR="$TERMUX_PREFIX/lib/gcc/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_VERSION/sysroot-compat"

termux_pkg_auto_update() {
	local major="${TERMUX_PKG_VERSION%%.*}"
	local latest
	latest="$(curl -fsSL --retry 3 https://mirrors.kernel.org/gnu/gcc/ |
		grep -oE "gcc-${major}\.[0-9]+\.0/" | sed -E 's|^gcc-||; s|/$||' |
		sort -V | tail -n1)"
	[[ -n "$latest" ]] || termux_error_exit "Unable to find the latest GCC ${major} release"
	termux_pkg_upgrade_version "$latest"
}

# Copies the headers the sysroot-compat patches touch, patches them and stores them in $1.
_gcc_make_compat_headers() {
	local dest="$1"
	local work="$TERMUX_PKG_TMPDIR/sysroot-compat-work"
	local p f
	rm -rf "$work" "$dest"
	mkdir -p "$work" "$dest"
	for p in "$TERMUX_PKG_BUILDER_DIR"/sysroot-compat/*.patch; do
		for f in $(sed -nE 's|^--- a/.*/usr/include/([^[:space:]]+).*|\1|p' "$p"); do
			[[ -e "$work/$f" ]] && continue
			mkdir -p "$work/$(dirname "$f")"
			cp "$TERMUX_PREFIX/include/$f" "$work/$f"
		done
	done
	for p in "$TERMUX_PKG_BUILDER_DIR"/sysroot-compat/*.patch; do
		patch --silent --forward -p8 -d "$work" -i "$p" ||
			termux_error_exit "Failed to apply $(basename "$p")"
	done
	find "$work" -name '*.orig' -delete
	cp -a "$work"/. "$dest"/
}

# Stage 1: x86_64 -> target cross compiler, used only to build the target libraries.
termux_step_host_build() {
	local cross="$TERMUX_PKG_HOSTBUILD_DIR/cross"
	local sysroot="$TERMUX_PKG_HOSTBUILD_DIR/sysroot"
	local binutils_cross="$TERMUX_PREFIX/opt/binutils/cross"
	local ndk_lib="$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL"

	[[ -x "$binutils_cross/bin/$TERMUX_HOST_PLATFORM-as" ]] ||
		termux_error_exit "binutils-cross is required to build the stage 1 compiler"

	mkdir -p "$sysroot/usr/include" "$sysroot/usr/lib"
	cp -a "$TERMUX_PREFIX/include"/. "$sysroot/usr/include/"
	_gcc_make_compat_headers "$TERMUX_PKG_HOSTBUILD_DIR/compat"
	cp -a "$TERMUX_PKG_HOSTBUILD_DIR/compat"/. "$sysroot/usr/include/"
	cp -a "$sysroot/usr/include/$TERMUX_HOST_PLATFORM"/. "$sysroot/usr/include/"
	cp -a "$ndk_lib"/. "$sysroot/usr/lib/"

	mkdir -p "$cross/$TERMUX_HOST_PLATFORM/bin"
	ln -sf "$binutils_cross/$TERMUX_HOST_PLATFORM/bin"/* "$cross/$TERMUX_HOST_PLATFORM/bin/"
	export PATH="$cross/bin:$binutils_cross/bin:$PATH"

	mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR/build"
	cd "$TERMUX_PKG_HOSTBUILD_DIR/build"
	CFLAGS_FOR_TARGET="-O2 -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL" \
	"$TERMUX_PKG_SRCDIR/configure" \
		--prefix="$cross" \
		--target="$TERMUX_HOST_PLATFORM" \
		--with-sysroot="$sysroot" \
		--with-build-time-tools="$binutils_cross/$TERMUX_HOST_PLATFORM/bin" \
		--enable-languages=c,c++,fortran \
		--enable-initfini-array \
		--enable-default-pie \
		--enable-eh-frame-hdr-for-static \
		--disable-bootstrap \
		--disable-nls \
		--disable-shared \
		--disable-multilib \
		--disable-tls \
		--disable-libssp \
		--disable-libstdcxx \
		--disable-libquadmath \
		--disable-libgomp \
		--disable-libatomic \
		--disable-libsanitizer \
		--without-isl \
		--with-system-zlib \
		$_ARCH_ARGS
	make -j "$TERMUX_PKG_MAKE_PROCESSES" all-gcc all-target-libgcc
	make install-gcc install-target-libgcc
}

termux_step_pre_configure() {
	export ac_cv_func_aligned_alloc=no
	export ac_cv_func__aligned_malloc=no
	export ac_cv_func_memalign=no
	export ac_cv_c_bigendian=no

	local cross="$TERMUX_PKG_HOSTBUILD_DIR/cross"
	local binutils_cross="$TERMUX_PREFIX/opt/binutils/cross"
	export PATH="$cross/bin:$binutils_cross/bin:$PATH"

	export CC_FOR_BUILD=gcc CXX_FOR_BUILD=g++
	export CFLAGS_FOR_BUILD="-O2" CXXFLAGS_FOR_BUILD="-O2" LDFLAGS_FOR_BUILD=""
	export CC_FOR_TARGET="$cross/bin/$TERMUX_HOST_PLATFORM-gcc"
	export CXX_FOR_TARGET="$cross/bin/$TERMUX_HOST_PLATFORM-g++"
	export GFORTRAN_FOR_TARGET="$cross/bin/$TERMUX_HOST_PLATFORM-gfortran"
	export CFLAGS_FOR_TARGET="-O2 -D__ANDROID_API__=$TERMUX_PKG_API_LEVEL"
	export CXXFLAGS_FOR_TARGET="$CFLAGS_FOR_TARGET"
	export FCFLAGS_FOR_TARGET="-O2"
	local t
	for t in AR AS LD NM OBJDUMP RANLIB READELF STRIP; do
		export "${t}_FOR_TARGET=$binutils_cross/bin/$TERMUX_HOST_PLATFORM-${t,,}"
	done

	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
		-e "s|@TERMUX_PKG_VERSION@|$TERMUX_PKG_VERSION|g" \
		-e "s|@COMPAT_DIR@|$_COMPAT_DIR|g" \
		-e "s|@ARCH_PLACEHOLDER@|$_ARCH_SPECS|g" \
		"$TERMUX_PKG_BUILDER_DIR/specs.in" > "$TERMUX_PKG_TMPDIR/specs"

}

termux_step_make() {
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_post_make_install() {
	local libdir="$TERMUX_PREFIX/lib/gcc/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_VERSION"
	cp "$TERMUX_PKG_TMPDIR/specs" "$libdir/specs"
	_gcc_make_compat_headers "$_COMPAT_DIR"

	mkdir -p "$TERMUX_PREFIX/$TERMUX_HOST_PLATFORM/include"
	ln -sfr "$TERMUX_PREFIX/include/$TERMUX_HOST_PLATFORM/asm" "$TERMUX_PREFIX/$TERMUX_HOST_PLATFORM/include/"
}
