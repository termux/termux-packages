TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="A GNU collection of binary utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# `lua-language-server` links against libbfd,
# remember to rebuild it when updating `binutils`.
TERMUX_PKG_VERSION="2.46.0"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d75a94f4d73e7a4086f7513e67e439e8fcdcbb726ffe63f4661744e6256b2cf2
TERMUX_PKG_DEPENDS="libc++, zlib, zstd"
TERMUX_PKG_BREAKS="binutils (<< 2.46), binutils-bin, binutils-libs, binutils-dev"
TERMUX_PKG_REPLACES="binutils (<< 2.46), binutils-bin, binutils-libs, binutils-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gprofng
--enable-plugins
--disable-werror
--with-system-zlib
--enable-new-dtags
"
TERMUX_PKG_EXTRA_MAKE_ARGS="tooldir=$TERMUX_PREFIX"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1"
TERMUX_PKG_NO_STATICSPLIT=true
# will overwrite llvm binutils and llvm ld
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_GROUPS="base-devel"

# For binutils-cross:
# Since NDK r27, debug sections of libraries from the bundled sysroot are
# compressed with zstd. It is necessary to enable the zstd support for ld.bfd.
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
--prefix=$TERMUX_PREFIX/opt/binutils/cross
--target=$TERMUX_HOST_PLATFORM
--enable-shared
--disable-static
--disable-nls
--with-system-zlib
--with-zstd
--disable-gprofng
ZSTD_LIBS=-l:libzstd.a
"

termux_step_post_get_source() {
	# Remove the marker every time, as binutils is architecture-specific.
	rm -rf "$TERMUX_HOSTBUILD_MARKER"

	# https://gitlab.archlinux.org/archlinux/packaging/packages/binutils/-/blob/2.46-1/PKGBUILD#L76-77
	# Turn off development mode (-Werror, gas run-time checks, date in sonames)
	sed -i '/^development=/s/true/false/' "$TERMUX_PKG_SRCDIR/bfd/development.sh"

}

termux_step_host_build() {
	# shellcheck disable=SC2086
	"$TERMUX_PKG_SRCDIR/configure" $TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	make install
	make install-strip
}

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

termux_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"

	LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib"
	if (( TERMUX_ARCH_BITS == 64 )); then
		LIB_PATH+="64"
	fi

	export LIB_PATH
}

termux_step_post_make_install() {
	rm "${TERMUX_PREFIX}/bin/ld"
	mv "${TERMUX_PREFIX}/share/man/man1/ld.1" \
		"${TERMUX_PREFIX}/share/man/man1/ld.bfd.1"
	local -a _BINUTILS_CONFLICTING_WITH_LLVM=(
		"ar"
		"addr2line"
		"c++filt"
		"nm"
		"objcopy"
		"objdump"
		"ranlib"
		"readelf"
		"size"
		"strings"
		"strip"
	)
	local binutil
	for binutil in "${_BINUTILS_CONFLICTING_WITH_LLVM[@]}"; do
		mv "${TERMUX_PREFIX}/bin/${binutil}" \
			"${TERMUX_PREFIX}/bin/g${binutil}"
		mv "${TERMUX_PREFIX}/share/man/man1/${binutil}.1" \
			"${TERMUX_PREFIX}/share/man/man1/g${binutil}.1"
	done
}
