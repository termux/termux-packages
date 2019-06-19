TERMUX_PKG_HOMEPAGE=https://elinux.org/Android_aapt
TERMUX_PKG_DESCRIPTION="Android Asset Packaging Tool"
TERMUX_PKG_LICENSE="Apache-2.0"
_TAG_VERSION=7.1.2
_TAG_REVISION=33
TERMUX_PKG_VERSION=${_TAG_VERSION}.${_TAG_REVISION}
TERMUX_PKG_REVISION=7
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libc++, libexpat, libpng, libzopfli, zlib"

termux_step_make_install() {
	# FIXME: We would like to enable checksums when downloading
	# tar files, but they change each time as the tar metadata
	# differs: https://github.com/google/gitiles/issues/84

	local _TAGNAME=${_TAG_VERSION}_r${_TAG_REVISION}

	SYSTEM_CORE_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/system_core_include_${_TAGNAME}.tar.gz
	test ! -f $SYSTEM_CORE_INCLUDE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include.tar.gz" \
		$SYSTEM_CORE_INCLUDE_TARFILE \
		SKIP_CHECKSUM

	ANDROIDFW_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/androidfw_include_${_TAGNAME}.tar.gz
	test ! -f $ANDROIDFW_INCLUDE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/include/androidfw.tar.gz" \
		$ANDROIDFW_INCLUDE_TARFILE \
		SKIP_CHECKSUM

	ANDROID_BASE_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/android_base_include_${_TAGNAME}.tar.gz
	test ! -f $ANDROID_BASE_INCLUDE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/base/include/android-base.tar.gz" \
		$ANDROID_BASE_INCLUDE_TARFILE \
		SKIP_CHECKSUM

	local AOSP_INCLUDE_DIR=$TERMUX_PREFIX/include/aosp
	mkdir -p $AOSP_INCLUDE_DIR
	cd $AOSP_INCLUDE_DIR
	rm -Rf *
	tar xf $SYSTEM_CORE_INCLUDE_TARFILE
	mkdir -p androidfw
	cd androidfw
	tar xf $ANDROIDFW_INCLUDE_TARFILE
	cd ..
	mkdir -p android-base
	cd android-base
	tar xf $ANDROID_BASE_INCLUDE_TARFILE
	cd ../log
	patch -p0 < $TERMUX_PKG_BUILDER_DIR/log.h.patch.txt

	CXXFLAGS+=" -fPIC"

	# Build libcutils:
	mkdir -p $TERMUX_PKG_SRCDIR/{libcutils,androidfw}
	cd $TERMUX_PKG_SRCDIR/libcutils
	LIBCUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libcutils_${_TAGNAME}.tar.gz
	test ! -f $LIBCUTILS_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libcutils.tar.gz" \
		$LIBCUTILS_TARFILE \
		SKIP_CHECKSUM
	tar xf $LIBCUTILS_TARFILE
	patch -p0 < $TERMUX_PKG_BUILDER_DIR/libcutils-patch.txt
	$CXX $CXXFLAGS -isystem $AOSP_INCLUDE_DIR -c -o sockets.o sockets.cpp
	$CXX $CXXFLAGS -isystem $AOSP_INCLUDE_DIR -c -o sockets_unix.o sockets_unix.cpp
	sed -i 's%include <sys/_system_properties.h>%include <sys/system_properties.h>%' properties.c
	# From Android.mk:
	libcutils_common_sources="\
		config_utils.c \
		fs_config.c \
		canned_fs_config.c \
		hashmap.c \
		iosched_policy.c \
		load_file.c \
		native_handle.c \
		open_memstream.c \
		process_name.c \
		record_stream.c \
		sched_policy.c \
		sockets.o \
		strdup16to8.c \
		strdup8to16.c \
		strlcpy.c \
		threads.c"
	libcutils_nonwindows_sources="\
		fs.c \
		multiuser.c \
		socket_inaddr_any_server_unix.c \
		socket_local_client_unix.c \
		socket_local_server_unix.c \
		socket_loopback_client_unix.c \
		socket_loopback_server_unix.c \
		socket_network_client_unix.c \
		sockets_unix.o \
		str_parms.c"
	# -D_FORTIFY_SOURCE=2 makes debug build fail with:
	# In file included from process_name.c:29:
	# /data/data/com.termux/files/usr/include/aosp/cutils/properties.h:116:45: error: expected identifier
	# __errordecl(__property_get_too_small_error, "property_get() called with too small of a buffer");
	#						^
	# /data/data/com.termux/files/usr/include/aosp/cutils/properties.h:119:5: error: static declaration of 'property_get' follows non-static declaration
	# int property_get(const char *key, char *value, const char *default_value) {
	#	^
	# /data/data/com.termux/files/usr/include/aosp/cutils/properties.h:46:5: note: previous declaration is here
	# int property_get(const char *key, char *value, const char *default_value);
	$CC ${CFLAGS/-D_FORTIFY_SOURCE=2/} \
		$LDFLAGS \
		-Dchar16_t=uint16_t \
		-std=c11 \
		-isystem $AOSP_INCLUDE_DIR \
		$libcutils_common_sources \
		$libcutils_nonwindows_sources \
		trace-host.c \
		properties.c \
		-llog \
		-shared \
		-o $TERMUX_PREFIX/lib/libandroid-cutils.so



	# Build libutil:
	local LIBUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libutils_${_TAGNAME}.tar.gz
	test ! -f $LIBUTILS_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libutils.tar.gz" \
		$LIBUTILS_TARFILE \
		SKIP_CHECKSUM

	local SAFE_IOP_TARFILE=$TERMUX_PKG_CACHEDIR/safe_iop.tar.gz
	test ! -f $SAFE_IOP_TARFILE && termux_download \
		https://android.googlesource.com/platform/external/safe-iop/+archive/cd76f998688d145235de78ecd5b340d0eac9239d.tar.gz \
		$SAFE_IOP_TARFILE \
		SKIP_CHECKSUM
	local SAFE_IOP_DIR=$TERMUX_PKG_TMPDIR/safe-iop
	mkdir -p $SAFE_IOP_DIR
	cd $SAFE_IOP_DIR
	tar xf $SAFE_IOP_TARFILE
	mv src/safe_iop.c src/safe_iop.cpp

	mkdir $TERMUX_PKG_SRCDIR/libutils
	cd $TERMUX_PKG_SRCDIR/libutils
	tar xf $LIBUTILS_TARFILE
	# From Android.mk:
	#CallStack.cpp \
	#SystemClock.cpp \
	commonSources="\
		FileMap.cpp \
		JenkinsHash.cpp \
		LinearTransform.cpp \
		Log.cpp \
		NativeHandle.cpp \
		Printer.cpp \
		PropertyMap.cpp \
		RefBase.cpp \
		SharedBuffer.cpp \
		Static.cpp \
		StopWatch.cpp \
		String8.cpp \
		String16.cpp \
		Threads.cpp \
		Timers.cpp \
		Tokenizer.cpp \
		Unicode.cpp \
		VectorImpl.cpp \
		misc.cpp"
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS \
		-std=c++11 \
		'-DALOG_ASSERT(a,...)=' \
		-Dtypeof=decltype \
		-isystem $TERMUX_PREFIX/include/aosp \
		-isystem $SAFE_IOP_DIR/include \
		$SAFE_IOP_DIR/src/safe_iop.cpp \
		$commonSources \
		-landroid-cutils \
		-llog \
		-shared \
		-o $TERMUX_PREFIX/lib/libandroid-utils.so



	# Build libbase:
	local LIBBASE_TARFILE=$TERMUX_PKG_CACHEDIR/libbase_${_TAGNAME}.tar.gz
	test ! -f $LIBBASE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-${_TAGNAME}/base.tar.gz" \
		$LIBBASE_TARFILE \
		SKIP_CHECKSUM
	mkdir -p $TERMUX_PKG_SRCDIR/libbase
	cd $TERMUX_PKG_SRCDIR/libbase
	tar xf $LIBBASE_TARFILE
	rm -Rf $TERMUX_PREFIX/include/aosp/android-base
	mv include/android-base $TERMUX_PREFIX/include/aosp
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/libbase-patch.txt
	#logging.cpp \
	libbase_src_files="\
		file.cpp \
		parsenetaddress.cpp \
		stringprintf.cpp \
		strings.cpp \
		test_utils.cpp"
	libbase_linux_src_files="\
		errors_unix.cpp"
	# __USE_BSD for DEFFILEMODE to be defined by <sys/stat.h>.
	$CXX $CXXFLAGS $CPPFLAGS \
		$LDFLAGS \
		-std=c++11 \
		-include memory \
		-D__USE_BSD \
		-isystem $AOSP_INCLUDE_DIR \
		$libbase_src_files $libbase_linux_src_files \
		-llog \
		-shared \
		-o $TERMUX_PREFIX/lib/libandroid-base.so


	# Build libziparchive:
	LIBZIPARCHIVE_TARFILE=$TERMUX_PKG_CACHEDIR/libziparchive_${_TAGNAME}.tar.gz
	test ! -f $LIBZIPARCHIVE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libziparchive.tar.gz" \
		$LIBZIPARCHIVE_TARFILE \
		SKIP_CHECKSUM
	mkdir -p $TERMUX_PKG_SRCDIR/libziparchive
	cd $TERMUX_PKG_SRCDIR/libziparchive
	tar xf $LIBZIPARCHIVE_TARFILE
	libziparchive_source_files="\
		zip_archive.cc \
		zip_archive_stream_entry.cc \
		zip_writer.cc"
	patch -p0 < $TERMUX_PKG_BUILDER_DIR/libziparchive.patch.txt
	$CXX $CPPFLAGS $CXXFLAGS $LDFLAGS -std=c++11 \
		-DZLIB_CONST \
		-isystem $AOSP_INCLUDE_DIR \
		$libziparchive_source_files \
		-landroid-base \
		-landroid-utils \
		-lz \
		-llog \
		-shared \
		-o $TERMUX_PREFIX/lib/libandroid-ziparchive.so



	# Build libandroidfw:
	ANDROIDFW_TARFILE=$TERMUX_PKG_CACHEDIR/androidfw_${_TAGNAME}.tar.gz
	test ! -f $ANDROIDFW_TARFILE && termux_download \
		https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/libs/androidfw.tar.gz \
		$ANDROIDFW_TARFILE \
		SKIP_CHECKSUM
	mkdir -p $TERMUX_PKG_SRCDIR/androidfw
	cd $TERMUX_PKG_SRCDIR/androidfw
	tar xf $ANDROIDFW_TARFILE
	commonSources="\
		Asset.cpp \
		AssetDir.cpp \
		AssetManager.cpp \
		LocaleData.cpp \
		misc.cpp \
		ObbFile.cpp \
		ResourceTypes.cpp \
		StreamingZipInflater.cpp \
		TypeWrappers.cpp \
		ZipFileRO.cpp \
		ZipUtils.cpp"
	sed -i 's%#include <binder/TextOutput.h>%%' ResourceTypes.cpp
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS -isystem $AOSP_INCLUDE_DIR \
		-std=c++11 \
		-include memory \
		$commonSources \
		-landroid-cutils \
		-landroid-utils \
		-landroid-ziparchive \
		-llog \
		-lz \
		-shared \
		-o $TERMUX_PREFIX/lib/libandroid-fw.so

	# Build aapt:
	AAPT_TARFILE=$TERMUX_PKG_CACHEDIR/aapt_${_TAGNAME}.tar.gz
	test ! -f $AAPT_TARFILE && termux_download \
		"https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/tools/aapt.tar.gz" \
		$AAPT_TARFILE \
		SKIP_CHECKSUM
	mkdir $TERMUX_PKG_SRCDIR/aapt
	cd $TERMUX_PKG_SRCDIR/aapt
	tar xf $AAPT_TARFILE
	sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PKG_BUILDER_DIR/aapt-Main.cpp.patch.txt | patch -p1
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS \
		-std=c++11 \
		-include memory \
		-DANDROID_SMP=1 \
		-DNDEBUG=1 \
		-DHAVE_ENDIAN_H=1 -DHAVE_POSIX_FILEMAP=1 -DHAVE_OFF64_T=1 -DHAVE_SYS_SOCKET_H=1 -DHAVE_PTHREADS=1 \
		-isystem $AOSP_INCLUDE_DIR \
		*.cpp \
		-landroid-cutils -landroid-utils -landroid-fw -landroid-ziparchive \
		-llog \
		-lm -lz -lpng -lexpat \
		-pie \
		-o $TERMUX_PREFIX/bin/aapt



	# Build zipalign:
	ZIPALIGN_TARFILE=$TERMUX_PKG_CACHEDIR/zipalign_${_TAGNAME}.tar.gz
	test ! -f $ZIPALIGN_TARFILE && termux_download \
		"https://android.googlesource.com/platform/build.git/+archive/android-$_TAGNAME/tools/zipalign.tar.gz" \
		$ZIPALIGN_TARFILE \
		SKIP_CHECKSUM
	mkdir $TERMUX_PKG_SRCDIR/zipalign
	cd $TERMUX_PKG_SRCDIR/zipalign
	tar xf $ZIPALIGN_TARFILE
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS \
		-isystem $AOSP_INCLUDE_DIR \
		-std=c++11 \
		ZipAlign.cpp ZipEntry.cpp ZipFile.cpp \
		-landroid-cutils -landroid-utils -landroid-fw \
		-lm -lz -llog \
		-lzopfli \
		-pie \
		-o $TERMUX_PREFIX/bin/zipalign


	# Remove this one for now:
	rm -Rf $AOSP_INCLUDE_DIR

	# Create an android.jar with AndroidManifest.xml and resources.arsc:
	cd $TERMUX_PKG_TMPDIR
	rm -rf android-jar
	mkdir android-jar
	cd android-jar
	cp $ANDROID_HOME/platforms/android-28/android.jar .
	unzip -q android.jar
	mkdir -p $TERMUX_PREFIX/share/aapt
	jar cfM $TERMUX_PREFIX/share/aapt/android.jar AndroidManifest.xml resources.arsc
}
