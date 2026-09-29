TERMUX_PKG_HOMEPAGE=https://sourceware.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.196"
TERMUX_PKG_SRCURL="https://sourceware.org/elfutils/ftp/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=fd5cc6b77ad6773cac93cb3f415f9318ac3b3455eecf801f6b4a742c4f6c7209
# libandroid-support for langinfo.
TERMUX_PKG_DEPENDS="libandroid-support, zlib, zstd, json-c"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c99=yes --disable-symbol-versioning"
TERMUX_PKG_CONFLICTS="libelf-dev"
TERMUX_PKG_REPLACES="libelf-dev"

# https://github.com/llvm/llvm-project/issues/71925#issuecomment-1987141438
#
# In file included from ../../elfutils-0.191/src/srcfiles.cxx:50:
# ...
# ./stack:1:1: error: expected unqualified-id
#
# do not set this to true due to clang bug
TERMUX_PKG_BUILD_IN_SRC=false

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-unused-const-variable -Wno-error=unused-function"
	CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error -Wno-error=unused-function"

	# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses
	CFLAGS+=" -D__USE_BSD"

	CFLAGS+=" -DFNM_EXTMATCH=0"

	CFLAGS+=" -I$TERMUX_PKG_SRCDIR/src"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		CFLAGS="${CFLAGS/-Oz/-O1}"
	fi

	cp $TERMUX_PKG_BUILDER_DIR/stdio_ext.h .
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h src
	cp $TERMUX_PKG_BUILDER_DIR/qsort_r.h .
	cp $TERMUX_PKG_BUILDER_DIR/aligned_alloc.c libelf
	cp -r $TERMUX_PKG_BUILDER_DIR/search src/

	autoreconf -ivf
}
