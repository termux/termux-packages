TERMUX_PKG_HOMEPAGE=http://openal-soft.org/
TERMUX_PKG_DESCRIPTION="Software implementation of the OpenAL API"
TERMUX_PKG_VERSION=1.19.1
TERMUX_PKG_SHA256=5c2f87ff5188b95e0dc4769719a9d89ce435b8322b4478b95dd4b427fe84b2e9
TERMUX_PKG_SRCURL=http://kcat.strangesoft.net/openal-releases/openal-soft-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_CMAKE_BUILD=Ninja
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DALSOFT_UTILS=ON
-DALSOFT_EXAMPLES=ON
-DALSOFT_TESTS=OFF
-DHAVE_PULSEAUDIO=OFF
"
termux_step_make() {
	ninja || cd native-tools
	CC= LD= CFLAGS= gcc ../../src/native-tools/bin2h.c -o bin2h
	CC= LD= CFLAGS= gcc  ../../src/native-tools/bsincgen.c -o bsincgen -lm
	cd ..
	ninja 
}
termux_step_post_make_install() {
	for bin in openal-info alrecord; do
	local SYSTEM_LIBFOLDER=lib64
        if [ $TERMUX_ARCH_BITS = 32 ]; then SYSTEM_LIBFOLDER=lib; fi
	mv $TERMUX_PREFIX/bin/$bin $TERMUX_PREFIX/libexec/$bin
	echo "#!/bin/sh" > $TERMUX_PREFIX/bin/$bin
	chmod +x $TERMUX_PREFIX/bin/$bin
	echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIBFOLDER:/system/vendor/$SYSTEM_LIBFOLDER:$TERMUX_PREFIX/lib exec $TERMUX_PREFIX/libexec/$bin \"\$@\"" >> $TERMUX_PREFIX/bin/$bin
	done
}

