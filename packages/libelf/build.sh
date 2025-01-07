TERMUX_PKG_HOMEPAGE=https://sourceware.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.191"
TERMUX_PKG_SRCURL="https://sourceware.org/elfutils/ftp/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=df76db71366d1d708365fc7a6c60ca48398f14367eb2b8954efc8897147ad871
# libandroid-support for langinfo.
TERMUX_PKG_DEPENDS="libandroid-support, zlib, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c99=yes --disable-symbol-versioning"
TERMUX_PKG_CONFLICTS="libelf-dev"
TERMUX_PKG_REPLACES="libelf-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-unused-const-variable -Wno-error=unused-function"
	CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error -Wno-error=unused-function"

	# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses
	CFLAGS+=" -D__USE_BSD"

	CFLAGS+=" -DFNM_EXTMATCH=0"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		CFLAGS="${CFLAGS/-Oz/-O1}"
	fi

	cp $TERMUX_PKG_BUILDER_DIR/stdio_ext.h .
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h .
	cp $TERMUX_PKG_BUILDER_DIR/qsort_r.h .
	cp $TERMUX_PKG_BUILDER_DIR/aligned_alloc.c libelf
	cp -r $TERMUX_PKG_BUILDER_DIR/search src/

	autoreconf -ivf
}
