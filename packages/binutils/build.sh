TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.39
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00
TERMUX_PKG_DEPENDS="binutils-libs (>= ${TERMUX_PKG_VERSION}), libc++, zlib"
TERMUX_PKG_SUGGESTS="ldd"
TERMUX_PKG_BREAKS="binutils-dev"
TERMUX_PKG_REPLACES="binutils-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
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
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
--prefix=$TERMUX_PREFIX/opt/binutils/cross
--target=$TERMUX_HOST_PLATFORM
--enable-shared
--disable-static
--disable-nls
--with-system-zlib
--disable-gprofng
"

termux_step_host_build() {
	$TERMUX_PKG_SRCDIR/configure $TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS
	make -j $TERMUX_MAKE_PROCESSES
	make install-strip
}

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

termux_step_pre_configure() {
	# Remove this marker all the time, as binutils is architecture-specific.
	rm -rf $TERMUX_HOSTBUILD_MARKER

	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib"
	else
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib64"
	fi
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	for b in ar ld nm objdump ranlib readelf strip; do
		ln -s -f $b $TERMUX_HOST_PLATFORM-$b
	done
	mv ld.bfd ld
	ln -sf ld.gold gold
}
