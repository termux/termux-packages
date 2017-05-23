TERMUX_PKG_HOMEPAGE=https://boost.org
TERMUX_PKG_DESCRIPTION="Free peer-reviewed portable C++ source libraries"
TERMUX_PKG_VERSION=1.64.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://sourceforge.net/projects/boost/files/boost/${TERMUX_PKG_VERSION}/boost_${TERMUX_PKG_VERSION//./_}.tar.bz2
TERMUX_PKG_SHA256=7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332
TERMUX_PKG_FOLDERNAME="boost_${TERMUX_PKG_VERSION//./_}"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libbz2"

termux_step_make_install() {
	rm $TERMUX_PREFIX/lib/libboost* -f
	rm $TERMUX_PREFIX/include/boost -rf

	./bootstrap.sh

	echo "using clang : $TERMUX_ARCH : $CXX : <linkflags>-L/data/data/com.termux/files/usr/lib ; " >> project-config.jam

	./b2 target-os=android -j${TERMUX_MAKE_PROCESSES} \
		include=/data/data/com.termux/files/usr/include \
		toolset=clang-$TERMUX_ARCH \
		--prefix="$TERMUX_PREFIX"  \
		-q \
		--without-coroutine2 \
		--without-coroutine \
		--without-context \
		--without-log \
		--without-python \
		--disable-icu \
		cxxflags="$CXXFLAGS" \
		link=shared \
		threading=multi \
		install
}
