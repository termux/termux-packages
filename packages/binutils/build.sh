TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/binutils/
TERMUX_PKG_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.32
TERMUX_PKG_REVISION=5
TERMUX_PKG_SHA256=9b0d97b3d30df184d302bced12f976aa1e5fbf4b0be696cdebc6cca30411a46e
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BREAKS="binutils-dev"
TERMUX_PKG_REPLACES="binutils-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gold --enable-plugins --disable-werror --with-system-zlib --enable-new-dtags"
TERMUX_PKG_EXTRA_MAKE_ARGS="tooldir=$TERMUX_PREFIX"
TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld.bfd"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_HAS_DEBUG=false
# Debug build fails with:
# ~/termux-build/binutils/src/binutils/readelf.c:19060:81: error: in call to 'fread', size * count is too large for the given buffer
#     if (fread (ehdr32.e_type, sizeof (ehdr32) - EI_NIDENT, 1, filedata->handle) != 1)
#                                                                               ^
# ~/termux-build/_cache/19b-aarch64-24-v5/bin/../sysroot/usr/include/bits/fortify/stdio.h:107:9: note: from 'diagnose_if' attribute on 'fread':
#        __clang_error_if(__bos(buf) != __BIONIC_FORTIFY_UNKNOWN_SIZE && size * count > __bos(buf),
#        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~/termux-build/_cache/19b-aarch64-24-v5/bin/../sysroot/usr/include/sys/cdefs.h:163:52: note: expanded from macro '__clang_error_if'
# #define __clang_error_if(cond, msg) __attribute__((diagnose_if(cond, msg, "error")))
#                                                    ^           ~~~~

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

termux_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib"
	else
		export LIB_PATH="${TERMUX_PREFIX}/lib:/system/lib64"
	fi
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/ldd $TERMUX_PREFIX/bin/ldd
	cd $TERMUX_PREFIX/bin
	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	for b in ar ld nm objdump ranlib readelf strip; do
		ln -s -f $b $TERMUX_HOST_PLATFORM-$b
	done
	ln -sf ld.gold gold
}
