TERMUX_PKG_HOMEPAGE=https://sourceware.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
TERMUX_PKG_VERSION=(0.173
		    1.3)
TERMUX_PKG_SHA256=(b76d8c133f68dad46250f5c223482c8299d454a69430d9aa5c19123345a000ff
		   dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be)
TERMUX_PKG_SRCURL=(ftp://sourceware.org/pub/elfutils/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2
		   http://www.lysator.liu.se/~nisse/archive/argp-standalone-${TERMUX_PKG_VERSION[1]}.tar.gz)
# libandroid-support for langinfo.
TERMUX_PKG_DEPENDS="libandroid-support, liblzma, libbz2"
TERMUX_PKG_CLANG=no
# Use "eu-" as program prefix to avoid conflict with binutils programs.
# This is what several linux distributions do.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--program-prefix='eu-'
--disable-symbol-versioning"
# The ar.c file is patched away for now:
TERMUX_PKG_RM_AFTER_INSTALL="bin/eu-ar"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error"

	# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses:
	CFLAGS+=" -D__USE_BSD"

	CFLAGS+=" -DFNM_EXTMATCH=0"

	cd argp-standalone-${TERMUX_PKG_VERSION[1]}
	ORIG_CFLAGS="$CFLAGS"
	CFLAGS+=" -std=gnu89"
	./configure --host=$TERMUX_HOST_PLATFORM
	make
	CFLAGS="$ORIG_CFLAGS"

	cp $TERMUX_PKG_BUILDER_DIR/error.h .
	cp $TERMUX_PKG_BUILDER_DIR/stdio_ext.h .
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h .
	cp $TERMUX_PKG_BUILDER_DIR/qsort_r.h .

	LDFLAGS+=" -L$TERMUX_PKG_SRCDIR/argp-standalone-${TERMUX_PKG_VERSION[1]}"
	CPPFLAGS+=" -isystem $TERMUX_PKG_SRCDIR/argp-standalone-${TERMUX_PKG_VERSION[1]}"
}
