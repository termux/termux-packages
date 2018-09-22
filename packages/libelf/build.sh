TERMUX_PKG_HOMEPAGE=https://sourceware.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
# NOTE: We only build the libelf part of elfutils for now,
# as other parts are not clang compatible.
TERMUX_PKG_VERSION=0.174
TERMUX_PKG_SHA256=cdf27e70076e10a29539d89e367101d516bc4aa11b0d7777fe52139e3fcad08a
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/elfutils/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2
# libandroid-support for langinfo.
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_BUILD_DEPENDS="argp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_c99=yes --disable-symbol-versioning"
TERMUX_PKG_CONFLICTS=elfutils
TERMUX_PKG_REPLACES=elfutils

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error"

	# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses:
	CFLAGS+=" -D__USE_BSD"

	CFLAGS+=" -DFNM_EXTMATCH=0"

	cp $TERMUX_PKG_BUILDER_DIR/error.h .
	cp $TERMUX_PKG_BUILDER_DIR/stdio_ext.h .
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h .
	cp $TERMUX_PKG_BUILDER_DIR/qsort_r.h .
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES -C lib
	make -j $TERMUX_MAKE_PROCESSES -C libelf
}

termux_step_make_install() {
	make -j $TERMUX_MAKE_PROCESSES -C libelf install
}
