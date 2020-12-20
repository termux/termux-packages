TERMUX_PKG_HOMEPAGE=https://sourceware.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# NOTE: We only build the libelf part of elfutils for now,
# as other parts are not clang compatible.
TERMUX_PKG_VERSION=0.182
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/elfutils/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ecc406914edf335f0b7fc084ebe6c460c4d6d5175bfdd6688c1c78d9146b8858
# libandroid-support for langinfo.
TERMUX_PKG_DEPENDS="libandroid-support, zlib, libcurl"
TERMUX_PKG_BUILD_DEPENDS="argp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c99=yes --disable-symbol-versioning --disable-debuginfod"
TERMUX_PKG_CONFLICTS="elfutils, libelf-dev"
TERMUX_PKG_REPLACES="elfutils, libelf-dev"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error"

	# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses:
	CFLAGS+=" -D__USE_BSD"

	CFLAGS+=" -DFNM_EXTMATCH=0"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		CFLAGS="${CFLAGS/-Oz/-O1}"
	fi

	cp $TERMUX_PKG_BUILDER_DIR/error.h .
	cp $TERMUX_PKG_BUILDER_DIR/stdio_ext.h .
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h .
	cp $TERMUX_PKG_BUILDER_DIR/qsort_r.h .
	cp $TERMUX_PKG_BUILDER_DIR/aligned_alloc.c libelf
	autoreconf -if
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES -C lib
	make -j $TERMUX_MAKE_PROCESSES -C libelf
	make -j $TERMUX_MAKE_PROCESSES -C libdwfl
	make -j $TERMUX_MAKE_PROCESSES -C libebl
	make -j $TERMUX_MAKE_PROCESSES -C backends
	make -j $TERMUX_MAKE_PROCESSES -C libcpu
	make -j $TERMUX_MAKE_PROCESSES -C libdwelf
	make -j $TERMUX_MAKE_PROCESSES -C libdw
}

termux_step_make_install() {
	make -j $TERMUX_MAKE_PROCESSES -C libelf install
	make -j $TERMUX_MAKE_PROCESSES -C libdwfl install
	make -j $TERMUX_MAKE_PROCESSES -C libdw install
	make -j $TERMUX_MAKE_PROCESSES -C libasm install
	make install-pkgincludeHEADERS
	make -C config install
}
