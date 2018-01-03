TERMUX_PKG_HOMEPAGE=https://sourceware.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
TERMUX_PKG_VERSION=0.170
TERMUX_PKG_SHA256=1f844775576b79bdc9f9c717a50058d08620323c1e935458223a12f249c9e066
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/elfutils/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2
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

	# Install argp lib.
	ARGP_FILE=$TERMUX_PKG_CACHEDIR/argp-standalone.1.3.tar.gz
	termux_download http://www.lysator.liu.se/~nisse/archive/argp-standalone-1.3.tar.gz \
	                $ARGP_FILE \
	                dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be

	cd $TERMUX_PKG_TMPDIR
	tar xf $ARGP_FILE
	cd argp-standalone-1.3
	ORIG_CFLAGS="$CFLAGS"
	CFLAGS+=" -std=gnu89"
	./configure --host=$TERMUX_HOST_PLATFORM
	make
	CFLAGS="$ORIG_CFLAGS"

	cp $TERMUX_PKG_BUILDER_DIR/error.h .
	cp $TERMUX_PKG_BUILDER_DIR/stdio_ext.h .
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h .
	cp $TERMUX_PKG_BUILDER_DIR/qsort_r.h .

	LDFLAGS+=" -L$TERMUX_PKG_TMPDIR/argp-standalone-1.3"
	CPPFLAGS+=" -isystem $TERMUX_PKG_TMPDIR/argp-standalone-1.3"
}
