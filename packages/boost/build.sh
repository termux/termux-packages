TERMUX_PKG_HOMEPAGE=https://boost.org
TERMUX_PKG_DESCRIPTION="Free peer-reviewed portable C++ source libraries"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
# Never forget to always bump revision of reverse dependencies and rebuild them
# when bumping version.
TERMUX_PKG_VERSION="1.87.0"
TERMUX_PKG_SRCURL=https://boostorg.jfrog.io/artifactory/main/release/$TERMUX_PKG_VERSION/source/boost_${TERMUX_PKG_VERSION//./_}.tar.bz2
TERMUX_PKG_SHA256=af57be25cb4c4f4b413ed692fe378affb4352ea50fbe294a11ef548f4d527d89
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++, libbz2, libiconv, liblzma, libandroid-wordexp, zlib"
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
	# https://www.boost.org/doc/libs/1_87_0/libs/unordered/doc/html/unordered.html#debuggability_gdb_pretty_printers
	# Disable this as it causes inline assembly errors on arm:
	# <inline asm>:1:41: error: expected '%<type>' or "<type>"
	#     1 | .pushsection ".debug_gdb_scripts", "MS",@progbits,1
	#       |                                         ^
	# <inline asm>:318:12: error: .popsection without corresponding .pushsection
	#   318 | .popsection
	#       |            ^
	# 2 errors generated.
	sed -i -e 's|#ifndef BOOST_ALL_NO_EMBEDDED_GDB_SCRIPTS|#if 0|g' \
		./boost/interprocess/interprocess_printers.hpp \
		./boost/unordered/unordered_printers.hpp \
		./boost/json/detail/config.hpp

	rm $TERMUX_PREFIX/lib/libboost* -f
	rm $TERMUX_PREFIX/include/boost -rf

	CC= CXX= LDFLAGS= CXXFLAGS= ./bootstrap.sh
	echo "using clang : $TERMUX_ARCH : $CXX : <linkflags>-L$TERMUX_PREFIX/lib ; " >> project-config.jam
	echo "using python : ${TERMUX_PYTHON_VERSION} : $TERMUX_PREFIX/bin/python3 : $TERMUX_PREFIX/include/python${TERMUX_PYTHON_VERSION} : $TERMUX_PREFIX/lib ;" >> project-config.jam

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
		--prefix="$TERMUX_PREFIX"  \
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
