TERMUX_PKG_HOMEPAGE=http://elinux.org/Android_aapt
TERMUX_PKG_DESCRIPTION="Library providing common functionalities for Android related tools"
TERMUX_PKG_VERSION=6.0.1
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="android-libcutils"

termux_step_make_install () {
        local _TAGNAME=${TERMUX_PKG_VERSION}_r5

	LIBUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libutils_${_TAGNAME}.tar.gz

	test ! -f $LIBUTILS_TARFILE && curl -o $LIBUTILS_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libutils.tar.gz"

        # https://android.googlesource.com/platform/system/core/+/android-4.4.4_r2/include/cutils/
        LIBUTILS_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/libcutils_include_${_TAGNAME}.tar.gz
	test ! -f $LIBUTILS_INCLUDE_TARFILE && curl -o $LIBUTILS_INCLUDE_TARFILE \
                "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include/utils.tar.gz"


        SYSTEM_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/system_include_${_TAGNAME}.tar.gz
	test ! -f $SYSTEM_INCLUDE_TARFILE && curl -o $SYSTEM_INCLUDE_TARFILE \
                "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include/system.tar.gz"


        mkdir -p libutils include/{utils,log,system}
        tar xf $LIBUTILS_INCLUDE_TARFILE -C include/utils
        tar xf $SYSTEM_INCLUDE_TARFILE -C include/system

	#cp $TERMUX_PKG_BUILDER_DIR/log.h include/log/

        cd libutils
        tar xf $LIBUTILS_TARFILE
	#rm dlmalloc_stubs.c ashmem-host.c properties.c fs_config.c trace-*.c
	rm BlobCache.cpp Looper.cpp Trace.cpp CallStack.cpp
	$CXX $CPPFLAGS -std=c++11 -isystem $TERMUX_PKG_SRCDIR/include *.cpp -shared -o $TERMUX_PREFIX/lib/libutils.so
}
