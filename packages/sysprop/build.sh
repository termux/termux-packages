TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/system/tools/sysprop
TERMUX_PKG_DESCRIPTION="Generates cpp / java sysprop"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_TAG_VERSION=13.0.0
_TAG_REVISION=15
TERMUX_PKG_VERSION=${_TAG_VERSION}.${_TAG_REVISION}
TERMUX_PKG_SRCURL=(https://android.googlesource.com/platform/system/tools/sysprop
                   https://android.googlesource.com/platform/system/core
                   https://android.googlesource.com/platform/system/libbase)
TERMUX_PKG_GIT_BRANCH=android-${_TAG_VERSION}_r${_TAG_REVISION}
TERMUX_PKG_SHA256=(SKIP_CHECKSUM
                   SKIP_CHECKSUM
                   SKIP_CHECKSUM)
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
# aapt is for libandroid-base.so
TERMUX_PKG_DEPENDS="aapt, libc++, libprotobuf"
TERMUX_PKG_BUILD_DEPENDS="fmt"

termux_step_post_get_source() {
	# FIXME: We would like to enable checksums when downloading
	# tar files, but they change each time as the tar metadata
	# differs: https://github.com/google/gitiles/issues/84

	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		git clone --depth 1 --single-branch \
			--branch $TERMUX_PKG_GIT_BRANCH \
			${TERMUX_PKG_SRCURL[$i]}
	done
}

termux_step_pre_configure() {
	termux_setup_protobuf

	CXXFLAGS+=" -fPIC -std=c++17"
	CPPFLAGS+=" -DNDEBUG -D__ANDROID_SDK_VERSION__=__ANDROID_API__"

	_TMP_LIBDIR=$TERMUX_PKG_SRCDIR/_lib
	rm -rf $_TMP_LIBDIR
	mkdir -p $_TMP_LIBDIR
	_TMP_BINDIR=$TERMUX_PKG_SRCDIR/_bin
	rm -rf $_TMP_BINDIR
	mkdir -p $_TMP_BINDIR

	LDFLAGS+=" -L$_TMP_LIBDIR"
}

termux_step_make() {
	. $TERMUX_PKG_BUILDER_DIR/sources.sh

	local LIBBASE_SRCDIR=$TERMUX_PKG_SRCDIR/libbase
	local LIBPROPERTYINFOPARSER_SRCDIR=$TERMUX_PKG_SRCDIR/core/property_service/libpropertyinfoparser
	local LIBPROPERTYINFOSERIALIZER_SRCDIR=$TERMUX_PKG_SRCDIR/core/property_service/libpropertyinfoserializer
	local SYSPROP_SRCDIR=$TERMUX_PKG_SRCDIR/sysprop

	CPPFLAGS+=" -I. -I./include"

	# Build libpropertyinfoparser:
	cd $LIBPROPERTYINFOPARSER_SRCDIR
	for f in $libpropertyinfoparser_sources; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$AR cru $_TMP_LIBDIR/libpropertyinfoparser.a *.o

	CPPFLAGS+=" -I$LIBPROPERTYINFOPARSER_SRCDIR/include"

	CPPFLAGS+=" -I$LIBBASE_SRCDIR/include"

	# Build libpropertyinfoserializer:
	cd $LIBPROPERTYINFOSERIALIZER_SRCDIR
	for f in $libpropertyinfoserializer_sources; do
		$CXX $CXXFLAGS $CPPFLAGS $f -c
	done
	$AR cru $_TMP_LIBDIR/libpropertyinfoserializer.a *.o

	CPPFLAGS+=" -I$LIBPROPERTYINFOSERIALIZER_SRCDIR/include"

	# Build sysprop:
	cd $SYSPROP_SRCDIR
	for f in $sysprop_proto; do
		protoc --cpp_out=. $f
	done
	local _LDFLAGS_SYSPROP="$LDFLAGS
		-landroid-base
		-lfmt
		-lpropertyinfoparser
		-lpropertyinfoserializer
		-lprotobuf"
	$CXX $CXXFLAGS $CPPFLAGS \
		$sysprop_sources \
		$sysprop_cpp_sources \
		$_LDFLAGS_SYSPROP \
		-o $_TMP_BINDIR/sysprop_cpp
	$CXX $CXXFLAGS $CPPFLAGS \
		$sysprop_sources \
		$sysprop_java_sources \
		$_LDFLAGS_SYSPROP \
		-o $_TMP_BINDIR/sysprop_java
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin \
		$_TMP_BINDIR/sysprop_{cpp,java}
}
