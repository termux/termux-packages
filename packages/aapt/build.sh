TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/system/core/+/android-4.4.4_r2/libutils
TERMUX_PKG_DESCRIPTION="Android Asset Packaging Tool"
TERMUX_PKG_VERSION=5.1.0
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libexpat, libpng, libgnustl"

termux_step_make_install () {
        local _TAGNAME=${TERMUX_PKG_VERSION}_r1

	LIBCUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libcutils_${_TAGNAME}.tar.gz
	LIBUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libutils_${_TAGNAME}.tar.gz
        ANDROIDFW_TARFILE=$TERMUX_PKG_CACHEDIR/androidfw_${_TAGNAME}.tar.gz
	AAPT_TARFILE=$TERMUX_PKG_CACHEDIR/aapt_${_TAGNAME}.tar.gz
	LIBZIPARCHIVE_TARFILE=$TERMUX_PKG_CACHEDIR/libziparchive_${_TAGNAME}.tar.gz
        ZIPALIGN_TARFILE=$TERMUX_PKG_CACHEDIR/zipalign_${_TAGNAME}.tar.gz

	test ! -f $LIBCUTILS_TARFILE && curl -o $LIBCUTILS_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libcutils.tar.gz"
	test ! -f $LIBUTILS_TARFILE && curl -o $LIBUTILS_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libutils.tar.gz"
	test ! -f $ANDROIDFW_TARFILE && curl -o $ANDROIDFW_TARFILE "https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/libs/androidfw.tar.gz"
	test ! -f $AAPT_TARFILE && curl -o $AAPT_TARFILE "https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/tools/aapt.tar.gz"
	test ! -f $ZIPALIGN_TARFILE && curl -o $ZIPALIGN_TARFILE "https://android.googlesource.com/platform/build.git/+archive/android-$_TAGNAME/tools/zipalign.tar.gz"
	test ! -f $LIBZIPARCHIVE_TARFILE && curl -o $LIBZIPARCHIVE_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libziparchive.tar.gz"

        # https://android.googlesource.com/platform/system/core/+/android-4.4.4_r2/include/cutils/
        LIBCUTILS_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/libcutils_include_${_TAGNAME}.tar.gz
	test ! -f $LIBCUTILS_INCLUDE_TARFILE && curl -o $LIBCUTILS_INCLUDE_TARFILE \
                "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include/cutils.tar.gz"
        # https://android.googlesource.com/platform/system/core/+/android-4.4.4_r2/include/utils/
        LIBUTILS_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/libutils_include_${_TAGNAME}.tar.gz
        test ! -f $LIBUTILS_INCLUDE_TARFILE && curl -o $LIBUTILS_INCLUDE_TARFILE \
                "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include/utils.tar.gz"
        # https://android.googlesource.com/platform/frameworks/base/+/android-4.4.4_r2/include/androidfw/
        ANDROIDFW_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/androidfw_include_${_TAGNAME}.tar.gz
        test ! -f $ANDROIDFW_INCLUDE_TARFILE && curl -o $ANDROIDFW_INCLUDE_TARFILE \
                "https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/include/androidfw.tar.gz"
	LIBZIPARCHIVE_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/libziparchive_include_${_TAGNAME}.tar.gz
        test ! -f $LIBZIPARCHIVE_INCLUDE_TARFILE && curl -o $LIBZIPARCHIVE_INCLUDE_TARFILE \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include/ziparchive.tar.gz"

        mkdir -p include/{cutils,utils,androidfw,log,system,ziparchive} libcutils libutils androidfw aapt zipalign ziparchive

        (cd include/cutils; tar xf $LIBCUTILS_INCLUDE_TARFILE)
        (cd include/utils; tar xf $LIBUTILS_INCLUDE_TARFILE; rm CallStack.h; touch CallStack.h)
        (cd include/androidfw; tar xf $ANDROIDFW_INCLUDE_TARFILE)
	(cd include/ziparchive; tar xf $LIBZIPARCHIVE_INCLUDE_TARFILE)
        touch include/system/graphics.h
        cp $TERMUX_PKG_BUILDER_DIR/log.h include/log/
        cp $TERMUX_PKG_BUILDER_DIR/thread_defs.h include/system/
        # to satisfy <libexpat/expat.h> include:
        ln -s "$TERMUX_PREFIX/include" include/libexpat

        cd libcutils
        tar xf $LIBCUTILS_TARFILE
        rm trace.c dlmalloc_stubs.c ashmem-host.c

        cd ../libutils
        tar xf $LIBUTILS_TARFILE
        rm CallStack.cpp ProcessCallStack.cpp Trace.cpp
        perl -p -i -e 's/__android_log_print\(mPriority, mLogTag,/printf(/' Printer.cpp

        cd ../androidfw
        tar xf $ANDROIDFW_TARFILE
        rm BackupData.cpp BackupHelpers.cpp CursorWindow.cpp

	cd ../ziparchive
	tar xf $LIBZIPARCHIVE_TARFILE
	rm zip_archive_test.cc

        # png_set_expand_gray_1_2_4_to_8(png_ptr) is the newer name instead of png_set_gray_1_2_4_to_8(png_ptr):
        # libpng no longer defines "#define png_sizeof(x) (sizeof (x))"
        # -include <zlib.h> since png.h no longer includes zlib.h
        COMPILE_FLAGS="$CC $CFLAGS \
                -DANDROID_SMP=1 \
                -DHAVE_ENDIAN_H=1 -DHAVE_POSIX_FILEMAP=1 -DHAVE_OFF64_T=1 -DHAVE_SYS_SOCKET_H=1 -DHAVE_PTHREADS=1 \
		-DNDEBUG=1 \
                -Dpng_set_gray_1_2_4_to_8=png_set_expand_gray_1_2_4_to_8 -Dpng_sizeof=sizeof -include zlib.h \
                -I $TERMUX_PKG_SRCDIR/include \
                -I $TERMUX_PREFIX/include \
                $LDFLAGS \
                -lm -lz -lpng -lexpat -lgnustl_shared \
		../libcutils/*.c ../ziparchive/*.cc ../libutils/*.cpp ../androidfw/*.cpp *.cpp"

        cd ../aapt
        tar xf $AAPT_TARFILE
        rm printapk.cpp
        perl -p -i -e 's/png_ptr->io_ptr/png_get_io_ptr(png_ptr)/' Images.cpp
        $COMPILE_FLAGS *.c -o $TERMUX_PREFIX/bin/aapt

	# zipalign needs "zopfli/deflate.h", so disable for now:
	#cd ../zipalign
	#tar xf $ZIPALIGN_TARFILE
	#$COMPILE_FLAGS -o $TERMUX_PREFIX/bin/zipalign
}
