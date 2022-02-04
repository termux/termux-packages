TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/system/tools/aidl
TERMUX_PKG_DESCRIPTION="Android Interface Definition Language (AIDL)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="NOTICE"
TERMUX_PKG_MAINTAINER="@termux"
_TAG_VERSION=7.1.2
_TAG_REVISION=33
TERMUX_PKG_VERSION=${_TAG_VERSION}.${_TAG_REVISION}
TERMUX_PKG_SRCURL=https://android.googlesource.com/platform/system/tools/aidl.git
TERMUX_PKG_GIT_BRANCH=android-${_TAG_VERSION}_r${_TAG_REVISION}
# Depends on libandroid-base
TERMUX_PKG_DEPENDS="aapt"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	local AAPT_BUILD_SH=$TERMUX_SCRIPTDIR/packages/aapt/build.sh
	local AAPT_TAG_VERSION=$(bash -c ". $AAPT_BUILD_SH; echo \$_TAG_VERSION")
	local AAPT_TAG_REVISION=$(bash -c ". $AAPT_BUILD_SH; echo \$_TAG_REVISION")
	local AAPT_TAGNAME=${AAPT_TAG_VERSION}_r${AAPT_TAG_REVISION}

	local LIBBASE_TARFILE=$TERMUX_PKG_CACHEDIR/libbase_${AAPT_TAGNAME}.tar.gz
	test ! -f $LIBBASE_TARFILE && termux_download \
		"https://android.googlesource.com/platform/system/core/+archive/android-${AAPT_TAGNAME}/base.tar.gz" \
		$LIBBASE_TARFILE \
		SKIP_CHECKSUM
	mkdir -p $TERMUX_PKG_SRCDIR/libbase
	cd $TERMUX_PKG_SRCDIR/libbase
	tar xf $LIBBASE_TARFILE
}

termux_step_host_build() {
	_PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/_prefix

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
	export PATH=$_PREFIX_FOR_BUILD/bin:$PATH

	CXXFLAGS+=" -fPIC"
	LDFLAGS+=" -llog"
}

termux_step_make() {
	flex aidl_language_l.ll
	bison --header=aidl_language_y.h aidl_language_y.yy
	cat >> aidl_language_y.h <<-EOF
		typedef union yy::parser::value_type YYSTYPE;
		typedef yy::parser::location_type YYLTYPE;
	EOF
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS \
		-I. -I./libbase/include \
		lex.yy.c \
		aidl_language_y.tab.cc \
		$(find . -maxdepth 1 \
			-name '*.cpp' -a \
			! -name '*_unittest.cpp' -a \
			! -name main_cpp.cpp) \
		libbase/logging.cpp \
		-landroid-base \
		-o aidl 
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin aidl
}
