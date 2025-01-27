TERMUX_PKG_HOMEPAGE=https://boost.org
TERMUX_PKG_DESCRIPTION="Free peer-reviewed portable C++ source libraries"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
# Never forget to always bump revision of reverse dependencies and rebuild them
# when bumping version.
TERMUX_PKG_VERSION="1:1.84.0"
_VERSION=${TERMUX_PKG_VERSION:2}
TERMUX_PKG_SRCURL="https://archives.boost.io/release/${_VERSION}/source/boost_${_VERSION//./_}.tar.bz2"
TERMUX_PKG_SHA256=cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, libbz2, libiconv, liblzma, zlib"
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_BREAKS="libboost-python (<= 1.65.1-2), boost-dev"
TERMUX_PKG_REPLACES="libboost-python (<= 1.65.1-2), boost-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_make_install() {
	CXXFLAGS+=" -std=c++14"

	rm $TERMUX_PREFIX/lib/libboost* -f
	rm $TERMUX_PREFIX/include/boost -rf

	CC= CXX= LDFLAGS= CXXFLAGS= ./bootstrap.sh
	echo "using clang : $TERMUX_ARCH : $CXX : <linkflags>-L$TERMUX_PREFIX/lib ; " >>project-config.jam
	echo "using python : ${TERMUX_PYTHON_VERSION} : $TERMUX_PREFIX/bin/python3 : $TERMUX_PREFIX/include/python${TERMUX_PYTHON_VERSION} : $TERMUX_PREFIX/lib ;" >>project-config.jam

	if [ "$TERMUX_ARCH" = arm ] || [ "$TERMUX_ARCH" = aarch64 ]; then
		BOOSTARCH=arm
		BOOSTABI=aapcs
	elif [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = x86_64 ]; then
		BOOSTARCH=x86
		BOOSTABI=sysv
	fi

	if [ "$TERMUX_ARCH" = x86_64 ] || [ "$TERMUX_ARCH" = aarch64 ]; then
		BOOSTAM=64
	elif [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = arm ]; then
		BOOSTAM=32
	fi

	./b2 target-os=android -j${TERMUX_PKG_MAKE_PROCESSES} \
		define=BOOST_FILESYSTEM_DISABLE_STATX \
		include=$TERMUX_PREFIX/include \
		toolset=clang-$TERMUX_ARCH \
		--prefix="$TERMUX_PREFIX" \
		-q \
		--without-stacktrace \
		--disable-icu \
		-sNO_ZSTD=1 \
		cxxflags="$CXXFLAGS" \
		linkflags="$LDFLAGS" \
		architecture="$BOOSTARCH" \
		abi="$BOOSTABI" \
		address-model="$BOOSTAM" \
		boost.locale.icu=off \
		binary-format=elf \
		threading=multi \
		install
}
