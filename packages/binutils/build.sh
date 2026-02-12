TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="A GNU collection of binary utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.46.0"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d75a94f4d73e7a4086f7513e67e439e8fcdcbb726ffe63f4661744e6256b2cf2
TERMUX_PKG_DEPENDS="binutils-bin, zlib, zstd"
TERMUX_PKG_BREAKS="binutils (<< 2.46), binutils-dev"
TERMUX_PKG_REPLACES="binutils (<< 2.46), binutils-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--bindir=$TERMUX_PREFIX/libexec/binutils
--disable-gprofng
--enable-plugins
--disable-werror
--with-system-zlib
--enable-new-dtags
"
TERMUX_PKG_EXTRA_MAKE_ARGS="tooldir=$TERMUX_PREFIX"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1"
TERMUX_PKG_NO_STATICSPLIT=true
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
	# Remove this marker all the time, as binutils is architecture-specific.
	rm -rf "$TERMUX_HOSTBUILD_MARKER"
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
	local dir="$TERMUX_PREFIX/share/binutils"
	mkdir -p "$dir"
	touch "$dir/.placeholder"

	mkdir -p "$TERMUX_PREFIX/bin"
	cd "$TERMUX_PREFIX/libexec/binutils" || termux_error_exit "failed to change into 'libexec/binutils' directory"

	mv ld{.bfd,}
	ln -sf ld{,.bfd}
	ln -sfr "$TERMUX_PREFIX/libexec/binutils/ld" "$TERMUX_PREFIX/bin/ld.bfd"

	local bin
	for bin in ./*; do
		ln -sfr "$TERMUX_PREFIX/libexec/binutils/$bin" \
			"$TERMUX_PREFIX/bin/$bin"
	done

	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	local -a _TOOLS_WITH_HOST_PREFIX=("ar" "ld" "nm" "objdump" "ranlib" "readelf" "strip")
	for bin in "${_TOOLS_WITH_HOST_PREFIX[@]}"; do
		ln -sfr "$TERMUX_PREFIX/libexec/binutils/$bin" \
			"$TERMUX_PREFIX/bin/$TERMUX_HOST_PLATFORM-$bin"
	done
}

termux_step_post_massage() {
	rm -rf bin
}
