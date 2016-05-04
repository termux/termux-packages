TERMUX_PKG_VERSION=0.166
TERMUX_PKG_HOMEPAGE=https://fedorahosted.org/elfutils/
TERMUX_PKG_DESCRIPTION="ELF object file access library"
TERMUX_PKG_SRCURL=https://fedorahosted.org/releases/e/l/elfutils/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2
# libandroid-support for langinfo.
TERMUX_PKG_DEPENDS="libandroid-support, liblzma, libbz2"
# Use "eu-" as program prefix to avoid conflict with binutils programs.
# This is what several linux distributions do.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--program-prefix='eu-'"
# The ar.c file is patched away for now:
TERMUX_PKG_RM_AFTER_INSTALL="bin/eu-ar"

LDFLAGS+=" -lintl"
CFLAGS+=" -DTERMUX_EXPOSE_MEMPCPY=1 -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error"

# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses:
CFLAGS+=" -D__USE_BSD"

termux_step_pre_configure () {
        # Install argp lib.
        ARGP_FILE=$TERMUX_PKG_CACHEDIR/argp-standalone.1.3.tar.gz
        if [ ! -f $ARGP_FILE ]; then
                curl -o $ARGP_FILE http://www.lysator.liu.se/~nisse/archive/argp-standalone-1.3.tar.gz
        fi

        cd $TERMUX_PKG_TMPDIR
        tar xf $ARGP_FILE
        cd argp-standalone-1.3
        ./configure --host=$TERMUX_HOST_PLATFORM
        make

        cp $TERMUX_PKG_BUILDER_DIR/error.h .
        cp $TERMUX_PKG_BUILDER_DIR/stdio_ext.h .
        cp $TERMUX_PKG_BUILDER_DIR/obstack.h .
        cp $TERMUX_PKG_BUILDER_DIR/qsort_r.h .

        LDFLAGS+=" -L$TERMUX_PKG_TMPDIR/argp-standalone-1.3"
        CPPFLAGS+=" -isystem $TERMUX_PKG_TMPDIR/argp-standalone-1.3"
}

#termux_step_post_make_install () {
#make install-includeHEADERS
#}

termux_step_post_massage () {
        # Remove to avoid spurios linking to libelf (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=10648):
        rm -f $TERMUX_PREFIX/lib/libelf*
}
