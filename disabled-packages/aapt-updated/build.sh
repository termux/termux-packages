# NOTE: Needs to be built with clang.
TERMUX_PKG_HOMEPAGE=http://elinux.org/Android_aapt
TERMUX_PKG_DESCRIPTION="Android Asset Packaging Tool"
TERMUX_PKG_VERSION=7.0.0
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libexpat, libpng"

termux_step_make_install () {
	local _TAGNAME=${TERMUX_PKG_VERSION}_r1

	SYSTEM_CORE_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/system_core_include_${_TAGNAME}.tar.gz
	test ! -f $SYSTEM_CORE_INCLUDE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/include.tar.gz" \
		$SYSTEM_CORE_INCLUDE_TARFILE
	
	ANDROIDFW_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/androidfw_include_${_TAGNAME}.tar.gz
	test ! -f $ANDROIDFW_INCLUDE_TARFILE && curl -o $ANDROIDFW_INCLUDE_TARFILE \
		"https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/include/androidfw.tar.gz"

	ANDROID_BASE_INCLUDE_TARFILE=$TERMUX_PKG_CACHEDIR/android_base_include_${_TAGNAME}.tar.gz
	test ! -f $ANDROID_BASE_INCLUDE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/base/include/android-base.tar.gz" \
		$ANDROID_BASE_INCLUDE_TARFILE

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

	mkdir -p $TERMUX_PKG_SRCDIR/{libcutils,androidfw}
	cd $TERMUX_PKG_SRCDIR/libcutils
	LIBCUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libcutils_${_TAGNAME}.tar.gz
	test ! -f $LIBCUTILS_TARFILE && curl -o $LIBCUTILS_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libcutils.tar.gz"
	tar xf $LIBCUTILS_TARFILE
	$CXX -isystem $AOSP_INCLUDE_DIR -c -o sockets.o sockets.cpp
	$CXX -isystem $AOSP_INCLUDE_DIR -c -o sockets_unix.o sockets_unix.cpp
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
	$CC \
		-Dchar16_t=uint16_t \
		-std=c11 \
		-isystem $AOSP_INCLUDE_DIR \
		$libcutils_common_sources \
		$libcutils_nonwindows_sources \
		trace-host.c \
		properties.c \
		-shared \
		-o $TERMUX_PREFIX/lib/libcutils.so

	ANDROIDFW_TARFILE=$TERMUX_PKG_CACHEDIR/androidfw_${_TAGNAME}.tar.gz
	test ! -f $ANDROIDFW_TARFILE && termux_download \
		https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/libs/androidfw.tar.gz \
		$ANDROIDFW_TARFILE
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
	$CXX $CXXFLAGS $LDFLAGS -isystem $AOSP_INCLUDE_DIR \
		-std=c++11 \
		$commonSources \
		-DACONFIGURATION_SCREENROUND_ANY=0x00 \
		-DACONFIGURATION_SCREENROUND_NO=0x1 \
		-DACONFIGURATION_SCREENROUND_YES=0x2 \
		-DACONFIGURATION_SCREEN_ROUND=0x8000 \
		-lcutils \
		-shared \
		-o $TERMUX_PREFIX/lib/libandroidfw.so



	# Build libutil:
	local LIBUTILS_TARFILE=$TERMUX_PKG_CACHEDIR/libutils_${_TAGNAME}.tar.gz
	test ! -f $LIBUTILS_TARFILE && curl -o $LIBUTILS_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libutils.tar.gz"

	local SAFE_IOP_TARFILE=$TERMUX_PKG_CACHEDIR/safe_iop.tar.gz
	test ! -f $SAFE_IOP_TARFILE && termux_download \
		https://android.googlesource.com/platform/external/safe-iop/+archive/cd76f998688d145235de78ecd5b340d0eac9239d.tar.gz \
		$SAFE_IOP_TARFILE
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
		SystemClock.cpp \
		Threads.cpp \
		Timers.cpp \
		Tokenizer.cpp \
		Unicode.cpp \
		VectorImpl.cpp \
		misc.cpp"
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS \
		-std=c++11 \
		-Dtypeof=decltype \
		-isystem $TERMUX_PREFIX/include/aosp \
		-isystem $SAFE_IOP_DIR/include \
		$SAFE_IOP_DIR/src/safe_iop.cpp \
		$commonSources \
		-lcutils \
		-shared \
		-o $TERMUX_PREFIX/lib/libutils.so



	# Build libbase:
	local LIBBASE_TARFILE=$TERMUX_PKG_CACHEDIR/libbase_${_TAGNAME}.tar.gz
	test ! -f $LIBBASE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-${_TAGNAME}/base.tar.gz" \
		$LIBBASE_TARFILE
	mkdir -p $TERMUX_PKG_SRCDIR/libbase
	cd $TERMUX_PKG_SRCDIR/libbase
	tar xf $LIBBASE_TARFILE
	rm -Rf $TERMUX_PREFIX/include/aosp/android-base
	mv include/android-base $TERMUX_PREFIX/include/aosp
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/libbase-patch.txt
	libbase_src_files="\
		file.cpp \
		logging.cpp \
		parsenetaddress.cpp \
		stringprintf.cpp \
		strings.cpp \
		test_utils.cpp"
	libbase_linux_src_files="\
		errors_unix.cpp"
	# __USE_BSD for DEFFILEMODE to be defined by <sys/stat.h>.
	$CXX $CPPFLAGS -std=c++11 \
		-D__USE_BSD \
		-isystem $AOSP_INCLUDE_DIR \
		$libbase_src_files $libbase_linux_src_files \
		-shared \
		-o $TERMUX_PREFIX/lib/libbase.so


	# Build libziparchive:
	LIBZIPARCHIVE_TARFILE=$TERMUX_PKG_CACHEDIR/libziparchive_${_TAGNAME}.tar.gz
	test ! -f $LIBZIPARCHIVE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-$_TAGNAME/libziparchive.tar.gz" \
		$LIBZIPARCHIVE_TARFILE
	mkdir -p $TERMUX_PKG_SRCDIR/libziparchive
	cd $TERMUX_PKG_SRCDIR/libziparchive
	tar xf $LIBZIPARCHIVE_TARFILE
	libziparchive_source_files="\
		zip_archive.cc \
		zip_archive_stream_entry.cc \
		zip_writer.cc"
	sed -i 's%next_in = reinterpret_cast<const uint8_t\*>(data)%next_in = const_cast<uint8_t\*>(reinterpret_cast<const uint8_t\*>(data))%' zip_writer.cc
	$CXX $CXXFLAGS $LDFLAGS -std=c++11 \
		-DZLIB_CONST \
		-isystem $AOSP_INCLUDE_DIR \
		$libziparchive_source_files \
		-lbase \
		-shared \
		-o $TERMUX_PREFIX/lib/libziparchive.so



	# Build aapt:
	AAPT_TARFILE=$TERMUX_PKG_CACHEDIR/aapt_${_TAGNAME}.tar.gz
	test ! -f $AAPT_TARFILE && curl -o $AAPT_TARFILE "https://android.googlesource.com/platform/frameworks/base/+archive/android-$_TAGNAME/tools/aapt.tar.gz"
	mkdir $TERMUX_PKG_SRCDIR/aapt
	cd $TERMUX_PKG_SRCDIR/aapt
	tar xf $AAPT_TARFILE
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS \
		-std=c++11 \
		-DANDROID_SMP=1 \
		-DNDEBUG=1 \
		-DHAVE_ENDIAN_H=1 -DHAVE_POSIX_FILEMAP=1 -DHAVE_OFF64_T=1 -DHAVE_SYS_SOCKET_H=1 -DHAVE_PTHREADS=1 \
		-DACONFIGURATION_SCREENROUND_ANY=0x00 \
		-DACONFIGURATION_SCREENROUND_NO=0x1 \
		-DACONFIGURATION_SCREENROUND_YES=0x2 \
		-DACONFIGURATION_SCREEN_ROUND=0x8000 \
		-isystem $AOSP_INCLUDE_DIR \
		*.cpp \
		-lcutils -lutils -landroidfw -lziparchive \
		-llog \
		-lm -lz -lpng -lexpat \
		-lgnustl_shared \
		-o $TERMUX_PREFIX/bin/aapt
}
