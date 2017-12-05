TERMUX_PKG_HOMEPAGE=https://www.lysator.liu.se/~nisse/misc/
TERMUX_PKG_DESCRIPTION="Standalone version of arguments parsing functions from GLIBC"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SRCURL=http://www.lysator.liu.se/~nisse/archive/argp-standalone-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be
TERMUX_PKG_KEEP_STATIC_LIBRARIES="true"
# libandroid-support for langinfo.
TERMUX_PKG_DEPENDS="libandroid-support, liblzma, libbz2"
TERMUX_PKG_CLANG=no
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
        CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error"

        # Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses:
        CFLAGS+=" -D__USE_BSD"

        CFLAGS+=" -std=gnu89"
}

termux_step_make_install() {
        make install
        cp libargp.a $TERMUX_PREFIX/lib
        cp argp.h $TERMUX_PREFIX/include
}
