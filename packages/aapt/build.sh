TERMUX_PKG_HOMEPAGE=https://elinux.org/Android_aapt
TERMUX_PKG_DESCRIPTION="Android Asset Packaging Tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_TAG_VERSION=12.0.0
_TAG_REVISION=27
TERMUX_PKG_VERSION=${_TAG_VERSION}.${_TAG_REVISION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(https://android.googlesource.com/platform/frameworks/base
                   https://android.googlesource.com/platform/system/core
                   https://android.googlesource.com/platform/system/libbase
                   https://android.googlesource.com/platform/system/libziparchive
                   https://android.googlesource.com/platform/system/logging
                   https://android.googlesource.com/platform/system/incremental_delivery
                   https://android.googlesource.com/platform/build
                   https://android.googlesource.com/platform/system/tools/aidl)
TERMUX_PKG_GIT_BRANCH=android-${_TAG_VERSION}_r${_TAG_REVISION}
TERMUX_PKG_SHA256=(SKIP_CHECKSUM
                   SKIP_CHECKSUM
                   SKIP_CHECKSUM
                   SKIP_CHECKSUM
                   SKIP_CHECKSUM
                   SKIP_CHECKSUM
                   SKIP_CHECKSUM
                   SKIP_CHECKSUM)
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libc++, libexpat, libpng, libzopfli, zlib"
TERMUX_PKG_BUILD_DEPENDS="fmt, googletest"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	# FIXME: We would like to enable checksums when downloading
	# tar files, but they change each time as the tar metadata
	# differs: https://github.com/google/gitiles/issues/84

	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		git clone --depth 1 --single-branch \
			--branch $TERMUX_PKG_GIT_BRANCH \
			${TERMUX_PKG_SRCURL[$i]}
	done

	for f in base/tools/aapt2/*.proto; do
		sed -i 's:frameworks/base/tools/aapt2/::' $f
	done

	# Get zopfli source:
	local ZOPFLI_VER=$(bash -c ". $TERMUX_SCRIPTDIR/packages/libzopfli/build.sh; echo \$TERMUX_PKG_VERSION")
	local ZOPFLI_SHA256=$(bash -c ". $TERMUX_SCRIPTDIR/packages/libzopfli/build.sh; echo \$TERMUX_PKG_SHA256")
	local ZOPFLI_TARFILE=$TERMUX_PKG_CACHEDIR/zopfli-${ZOPFLI_VER}.tar.gz
	termux_download \
		"https://github.com/google/zopfli/archive/zopfli-${ZOPFLI_VER}.tar.gz" \
		$ZOPFLI_TARFILE \
		$ZOPFLI_SHA256
	tar xf $ZOPFLI_TARFILE
	mv zopfli-zopfli-$ZOPFLI_VER zopfli
}

termux_step_host_build() {
	_PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/_prefix

	# Need bison that understands --header=[FILE] option.
	local BISON_BUILD_SH=$TERMUX_SCRIPTDIR/packages/bison/build.sh
	local BISON_SRCURL=$(bash -c ". $BISON_BUILD_SH; echo \$TERMUX_PKG_SRCURL")
	local BISON_SHA256=$(bash -c ". $BISON_BUILD_SH; echo \$TERMUX_PKG_SHA256")
	local BISON_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $BISON_SRCURL)
	termux_download $BISON_SRCURL $BISON_TARFILE $BISON_SHA256
	mkdir -p bison
	cd bison
	tar xf $BISON_TARFILE --strip-components=1
	./configure --prefix=$_PREFIX_FOR_BUILD
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	termux_setup_protobuf

	export PATH=$_PREFIX_FOR_BUILD/bin:$PATH

	CFLAGS+=" -fPIC"
	CXXFLAGS+=" -fPIC -std=c++17"
	CPPFLAGS+=" -D__ANDROID_SDK_VERSION__=__ANDROID_API__"

	_TMP_LIBDIR=$TERMUX_PKG_SRCDIR/_lib
	rm -rf $_TMP_LIBDIR
	mkdir -p $_TMP_LIBDIR
	_TMP_BINDIR=$TERMUX_PKG_SRCDIR/_bin
	rm -rf $_TMP_BINDIR
	mkdir -p $_TMP_BINDIR

	LDFLAGS+=" -llog -L$_TMP_LIBDIR"
}

termux_step_make() {
	. $TERMUX_PKG_BUILDER_DIR/sources.sh

	local CORE_INCDIR=$TERMUX_PKG_SRCDIR/core/include
	local LIBLOG_INCDIR=$TERMUX_PKG_SRCDIR/logging/liblog/include
	local LIBBASE_SRCDIR=$TERMUX_PKG_SRCDIR/libbase
	local LIBCUTILS_SRCDIR=$TERMUX_PKG_SRCDIR/core/libcutils
	local LIBUTILS_SRCDIR=$TERMUX_PKG_SRCDIR/core/libutils
	local INCFS_SUPPORT_INCDIR=$TERMUX_PKG_SRCDIR/libziparchive/incfs_support/include
	local LIBZIPARCHIVE_SRCDIR=$TERMUX_PKG_SRCDIR/libziparchive
	local INCFS_UTIL_SRCDIR=$TERMUX_PKG_SRCDIR/incremental_delivery/incfs/util
	local ANDROIDFW_SRCDIR=$TERMUX_PKG_SRCDIR/base/libs/androidfw
	local AAPT_SRCDIR=$TERMUX_PKG_SRCDIR/base/tools/aapt
	local LIBIDMAP2_POLICIES_INCDIR=$TERMUX_PKG_SRCDIR/base/cmds/idmap2/libidmap2_policies/include
	local AAPT2_SRCDIR=$TERMUX_PKG_SRCDIR/base/tools/aapt2
	local ZIPALIGN_SRCDIR=$TERMUX_PKG_SRCDIR/build/tools/zipalign
	local AIDL_SRCDIR=$TERMUX_PKG_SRCDIR/aidl

	CPPFLAGS+=" -I. -I./include
		-I$LIBBASE_SRCDIR/include
		-I$LIBLOG_INCDIR
		-I$CORE_INCDIR"

	# Build libcutils:
	cd $LIBCUTILS_SRCDIR
	for f in $libcutils_sources; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$CC $CFLAGS *.o -shared $LDFLAGS \
		-o $_TMP_LIBDIR/libandroid-cutils.so

	# Build libutils:
	cd $LIBUTILS_SRCDIR
	for f in $libutils_sources; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$CXX $CXXFLAGS *.o -shared $LDFLAGS \
		-landroid-cutils \
		-o $_TMP_LIBDIR/libandroid-utils.so

	# Build libbase:
	cd $LIBBASE_SRCDIR
	for f in $libbase_sources; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$CXX $CXXFLAGS *.o -shared $LDFLAGS \
		-o $_TMP_LIBDIR/libandroid-base.so

	# Build libziparchive:
	cd $LIBZIPARCHIVE_SRCDIR
	for f in $libziparchive_sources; do
		$CXX $CXXFLAGS -std=c++20 $CPPFLAGS -I$INCFS_SUPPORT_INCDIR $f -c
	done
	$CXX $CXXFLAGS *.o -shared $LDFLAGS \
		-landroid-base \
		-lz \
		-o $_TMP_LIBDIR/libandroid-ziparchive.so

	CPPFLAGS+=" -I$LIBZIPARCHIVE_SRCDIR/include"

	CPPFLAGS+=" -I$INCFS_UTIL_SRCDIR/include"

	# Build libandroidfw:
	cd $ANDROIDFW_SRCDIR
	for f in $androidfw_sources $INCFS_UTIL_SRCDIR/map_ptr.cpp; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$CXX $CXXFLAGS *.o -shared $LDFLAGS \
		-landroid-base \
		-landroid-cutils \
		-landroid-ziparchive \
		-o $_TMP_LIBDIR/libandroid-fw.so

	CPPFLAGS+=" -I$ANDROIDFW_SRCDIR/include"

	# Build aapt:
	cd $AAPT_SRCDIR
	for f in *.cpp; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$CXX $CXXFLAGS *.o $LDFLAGS \
		-landroid-fw \
		-landroid-utils \
		-lexpat \
		-lpng \
		-lz \
		-o $_TMP_BINDIR/aapt

	# Build aapt2:
	cd $AAPT2_SRCDIR
	for f in $libaapt2_proto; do
		protoc --cpp_out=. $f
	done
	for f in $aapt2_sources; do
		$CXX $CXXFLAGS $CPPFLAGS -I$LIBIDMAP2_POLICIES_INCDIR \
			$f -c -o ${f%.*}.o
	done
	$CXX $CXXFLAGS $(find . -name '*.o') $LDFLAGS \
		-landroid-base \
		-landroid-fw \
		-landroid-utils \
		-landroid-ziparchive \
		-lexpat \
		-lpng \
		-lprotobuf \
		-o $_TMP_BINDIR/aapt2

	# Build zipalign:
	cd $ZIPALIGN_SRCDIR
	for f in *.cpp; do
		$CXX $CXXFLAGS $CPPFLAGS -I$TERMUX_PKG_SRCDIR/zopfli/src $f -c
	done
	$CXX $CXXFLAGS *.o $LDFLAGS \
		-landroid-utils \
		-landroid-ziparchive \
		-lzopfli \
		-lz \
		-o $_TMP_BINDIR/zipalign

	# Build aidl:
	cd $AIDL_SRCDIR
	flex aidl_language_l.ll
	bison --header=aidl_language_y.h aidl_language_y.yy
	cat >> aidl_language_y.h <<-EOF
		typedef union yy::parser::value_type YYSTYPE;
		typedef yy::parser::location_type YYLTYPE;
	EOF
	for f in $aidl_sources; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$CXX $CXXFLAGS *.o $LDFLAGS \
		-landroid-base \
		-lfmt \
		-lgtest \
		-o $_TMP_BINDIR/aidl
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib \
		$_TMP_LIBDIR/libandroid-{cutils,utils,base,ziparchive,fw}.so
	install -Dm700 -t $TERMUX_PREFIX/bin \
		$_TMP_BINDIR/{aapt,aapt2,zipalign,aidl}

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
