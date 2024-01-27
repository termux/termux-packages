TERMUX_PKG_HOMEPAGE=https://github.com/grame-cncm/faust
TERMUX_PKG_DESCRIPTION="A functional programming language for signal processing and sound synthesis"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux, @harieamjari"
TERMUX_PKG_VERSION=2.70.3
TERMUX_PKG_SRCURL=https://github.com/grame-cncm/faust/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=644484f95167fe63014eac3db410f50c58810289fea228a2221e07d27da50eec
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR/build
	mkdir faustdir && cd faustdir
	termux_setup_cmake

	# Configure `make compiler`. build only the faust compiler.
	# these values are copied from build/Makefile:323
	cmake -C ../backends/regular.cmake \
		-C ../targets/regular.cmake \
		-DCMAKE_BUILD_TYPE=Release \
		"-DWORKLET=off" \
		-DINCLUDE_LLVM=OFF \
		-DUSE_LLVM_CONFIG=ON \
		-DLLVM_PACKAGE_VERSION= \
		-DLLVM_LIBS="" \
		-DLLVM_LIB_DIR="" \
		-DLLVM_INCLUDE_DIRS="" \
		-DLLVM_DEFINITIONS="" \
		-DLLVM_LD_FLAGS="" \
		-DLIBSDIR=lib \
		-DBUILD_HTTP_STATIC=OFF \
		-DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$TERMUX_PREFIX \
		-DCMAKE_INSTALL_LIBDIR=$TERMUX_PREFIX/lib \
		-DCMAKE_C_FLAGS="-DANDROID $CFLAGS $CPPFLAGS" \
		-DCMAKE_CXX_FLAGS="-DANDROID $CXXFLAGS $CPPFLAGS" \
		-DCMAKE_SKIP_INSTALL_RPATH=ON \
		-DCMAKE_USE_SYSTEM_LIBRARIES=True \
		-DDOXYGEN_EXECUTABLE= \
		-DBUILD_TESTING=OFF \
		-G 'Unix Makefiles' ..
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	make -C build
}

termux_step_make_install() {
	make -C build install PREFIX=$TERMUX_PREFIX
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin/

	# these are pretty much unusable inside Termux; requiring QT/Jack/Unity
	for i in alqt \
		caqt \
		jackserver \
		jaqtchain \
		lv2 \
		netjackqt \
		paqt \
		raqt \
		linuxunity \
		jack \
		jaqt \
		jackrust \
		jackconsole; do
		rm faust2${i}
	done

	sed -i 's/usage.sh/faustusage.sh/g' $(find . -type f -exec grep -Iq . {} \+ -print)
	mv usage.sh faustusage.sh

	cd $TERMUX_PREFIX/share/faust
	rm -rf android iOS esp32 unity smartKeyboard julia
}
