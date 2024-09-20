TERMUX_PKG_HOMEPAGE=https://github.com/grame-cncm/faust
TERMUX_PKG_DESCRIPTION="A functional programming language for signal processing and sound synthesis"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.75.7"
TERMUX_PKG_SRCURL=https://github.com/grame-cncm/faust/releases/download/${TERMUX_PKG_VERSION}/faust-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89cfed24e0dabfc344fd9ecea746719cc3dd274f1a8ac283da760f59bf009c87
TERMUX_PKG_AUTO_UPDATE=true
# Faust is licensed under LGPL 2.1
# The faustlibraries are licensed under the: STK 4.3.0 License
TERMUX_PKG_LICENSE="LGPL-2.1, custom"
TERMUX_PKG_LICENSE_FILE="COPYING.txt, libraries/licenses/stk-4.3.0.md"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR/build
	mkdir faustdir && cd faustdir
	termux_setup_cmake

	# Build the faust compiler with backends for various language + faust API libraries
	# these values are copied from build/Makefile:323
	cmake -C ../backends/light.cmake \
		-C ../targets/all.cmake \
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
	make -C build PREFIX=$TERMUX_PREFIX
}

termux_step_make_install() {
	make -C build install PREFIX=$TERMUX_PREFIX
	cd libraries
	cp *.lib old/*.lib $TERMUX_PREFIX/share/faust
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin

	# these are pretty much unusable inside Termux; requiring QT/Jack/Unity
	for i in alqt caqt jackserver jaqtchain lv2 netjackqt paqt cagtk dummymem rosgtk \
		raqt linuxunity jack jaqt jackrust jackconsole dummy; do
		rm faust2${i}
	done

	mv usage.sh faustusage.sh
	# find all ASCII scripts
	local faustscripts=$(find . -type f -exec grep -Iq . {} \; -print)

	sed -i 's/usage.sh/faustusage.sh/g' $faustscripts

	# We need to replace all instance of "/usr" with $TERMUX_PREFIX but we can't do it
	# in one go since $TERMUX_PREFIX also contain "/usr" so we risk doubling the prefix:
	# "/data/data/com.termux/files/data/data/com.termux/files/usr"

	sed -i "s@$TERMUX_PREFIX@\$TERMUX_PREFIX@g" $faustscripts
	sed -i "s@/usr/local@\$TERMUX_PREFIX@g" $faustscripts
	sed -i "s@/usr@\$TERMUX_PREFIX@g" $faustscripts

	# turns /tmp and /var with $TERMUX_PREFIX_{tmp,var}
	for i in tmp var; do
		sed -i "s@\$TERMUX_PREFIX/${i}/@\$TERMUX_PREFIX_${i}@g" $faustscripts
		perl -pi -e 's@(?<=("|[^[:alnum:]_\.]))/'${i}'(?=(/|\s))@\$TERMUX_PREFIX_'${i}'@g' \
			$faustscripts
	done

	# restore
	for i in tmp var; do
		sed -i "s@\$TERMUX_PREFIX_${i}@\$TERMUX_PREFIX/${i}@g" $faustscripts
	done
	sed -i "s@\$TERMUX_PREFIX@$TERMUX_PREFIX@g" $faustscripts

	cd $TERMUX_PREFIX/share/faust
	rm jack-*.cpp && rm *-gtk.{c,cpp} *-qt.cpp
}
