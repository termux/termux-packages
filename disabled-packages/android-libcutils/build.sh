TERMUX_PKG_HOMEPAGE=http://elinux.org/Android_aapt
TERMUX_PKG_DESCRIPTION="Library providing common functionalities for Android related tools"
TERMUX_PKG_VERSION=6.0.1
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
        local _TAGNAME=${TERMUX_PKG_VERSION}_r5

	LIBCUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libcutils_${_TAGNAME}.tar.gz

	test ! -f $LIBCUTILS_TARFILE && curl -o $LIBCUTILS_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libcutils.tar.gz"

        # https://android.googlesource.com/platform/system/core/+/android-4.4.4_r2/include/cutils/
        LIBCUTILS_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/libcutils_include_${_TAGNAME}.tar.gz
	test ! -f $LIBCUTILS_INCLUDE_TARFILE && curl -o $LIBCUTILS_INCLUDE_TARFILE \
                "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include/cutils.tar.gz"

        mkdir -p libcutils include/{cutils,log}
        tar xf $LIBCUTILS_INCLUDE_TARFILE -C include/cutils

	cp $TERMUX_PKG_BUILDER_DIR/log.h include/log/
	cp $TERMUX_PKG_BUILDER_DIR/log.h include/cutils/

	cp -Rf include/cutils $TERMUX_PREFIX/include/cutils

        cd libcutils
        tar xf $LIBCUTILS_TARFILE
        rm dlmalloc_stubs.c ashmem-host.c properties.c fs_config.c trace-*.c
	$CC -isystem $TERMUX_PKG_SRCDIR/include *.c -shared -o $TERMUX_PREFIX/lib/libcutils.so
}
