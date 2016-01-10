TERMUX_PKG_HOMEPAGE=http://elinux.org/Android_aapt
TERMUX_PKG_DESCRIPTION="Library providing common functionalities for Android related tools"
TERMUX_PKG_VERSION=6.0.1
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
        local _TAGNAME=${TERMUX_PKG_VERSION}_r5

	BASE_TARFILE=$TERMUX_PKG_CACHEDIR/base_${_TAGNAME}.tar.gz

	test ! -f $BASE_TARFILE && curl -o $BASE_TARFILE "https://android.googlesource.com/platform/system/core/+archive/android-${_TAGNAME}/base.tar.gz"

        tar xf $BASE_TARFILE
	rm test_*.cpp *_test.cpp
	$CXX $CPPFLAGS -std=c++11 -isystem $TERMUX_PKG_SRCDIR/include *.cpp -shared -o $TERMUX_PREFIX/lib/libbase.so
}
