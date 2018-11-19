TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
TERMUX_PKG_VERSION=2.31.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gold --enable-plugins --disable-werror --with-system-zlib --enable-new-dtags"
TERMUX_PKG_EXTRA_MAKE_ARGS="tooldir=$TERMUX_PREFIX"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld.bfd"
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

termux_step_pre_configure () {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib"
	else
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib64"
	fi
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/ldd $TERMUX_PREFIX/bin/ldd
	cd $TERMUX_PREFIX/bin
	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	for b in ar ld nm objdump ranlib readelf strip; do
		ln -s -f $b $TERMUX_HOST_PLATFORM-$b
	done
        ln -sf ld.gold gold
}
