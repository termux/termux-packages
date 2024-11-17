TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="GNU Binutils libraries"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.43.1"
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=13f74202a3c4c51118b797a39ea4200d3f6cfbe224da6d1d95bb938480132dfd
TERMUX_PKG_DEPENDS="libandroid-spawn, zlib, zstd"
TERMUX_PKG_BREAKS="binutils (<< 2.39), binutils-dev"
TERMUX_PKG_REPLACES="binutils (<< 2.39), binutils-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--bindir=$TERMUX_PREFIX/libexec/binutils
--enable-gold
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
	rm -rf $TERMUX_HOSTBUILD_MARKER
}

termux_step_host_build() {
	$TERMUX_PKG_SRCDIR/configure $TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make install
	make install-strip
}

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

termux_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"
	export LDFLAGS+=" -landroid-spawn"
	# llvm upgraded a warning to an error, which caused this build (and some
	# others, including the rust toolchain) to fail like so:
	#
	# ld.lld: error: version script assignment of 'LIBCTF_1.0' to symbol 'ctf_label_set' failed: symbol not defined
	# ld.lld: error: version script assignment of 'LIBCTF_1.0' to symbol 'ctf_label_get' failed: symbol not defined
	# These flags restore it to a warning.
	# https://reviews.llvm.org/D135402
	export LDFLAGS="$LDFLAGS -Wl,--undefined-version"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib"
	else
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib64"
	fi
}

termux_step_post_make_install() {
	local d=$TERMUX_PREFIX/share/binutils
	mkdir -p ${d}
	touch ${d}/.placeholder

	mkdir -p $TERMUX_PREFIX/bin
	cd $TERMUX_PREFIX/libexec/binutils

	mv ld{.bfd,}
	ln -sf ld{,.bfd}
	ln -sfr $TERMUX_PREFIX/libexec/binutils/ld $TERMUX_PREFIX/bin/ld.bfd

	rm -f $TERMUX_PREFIX/bin/ld.gold
	mv ld.gold $TERMUX_PREFIX/bin/
	ln -sfr $TERMUX_PREFIX/bin/{ld.,}gold

	for b in *; do
		ln -sfr $TERMUX_PREFIX/libexec/binutils/${b} \
			$TERMUX_PREFIX/bin/${b}
	done

	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	local _TOOLS_WITH_HOST_PREFIX="ar ld nm objdump ranlib readelf strip"
	for b in ${_TOOLS_WITH_HOST_PREFIX}; do
		ln -sfr $TERMUX_PREFIX/libexec/binutils/${b} \
			$TERMUX_PREFIX/bin/$TERMUX_HOST_PLATFORM-${b}
	done
}

termux_step_post_massage() {
	rm -rf bin
}
