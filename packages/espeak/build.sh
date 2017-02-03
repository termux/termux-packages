TERMUX_PKG_HOMEPAGE=https://github.com/espeak-ng/espeak-ng
TERMUX_PKG_DESCRIPTION="Compact software speech synthesizer"
# Use eSpeak NG as the original eSpeak project is dead.
# See https://github.com/espeak-ng/espeak-ng/issues/180
# about cross compilation of espeak-ng.
TERMUX_PKG_VERSION=1.49.1
TERMUX_PKG_SRCURL=https://github.com/espeak-ng/espeak-ng/releases/download/${TERMUX_PKG_VERSION}/espeak-ng-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4502c6e352d587fda326e8a55763e7d7c28b40e82c9c4683258ecc0a339ed0d4
TERMUX_PKG_FOLDERNAME=espeak-ng-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_HOSTBUILD=yes
# --without-async due to that using pthread_cancel().
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-async"

termux_step_host_build() {
	cp -Rf $TERMUX_PKG_SRCDIR/* .
	unset MAKEFLAGS
	./configure --prefix=$TERMUX_PREFIX
	make -j$TERMUX_MAKE_PROCESSES src/{e,}speak-ng

	# Man pages require the ronn ruby program.
	#make src/espeak-ng.1
	#cp src/espeak-ng.1 $TERMUX_PREFIX/share/man/man1
	#(cd $TERMUX_PREFIX/share/man/man1 && ln -s -f espeak-ng.1 espeak.1)

	make install
}

termux_step_make() {
	# Prevent caching of host build:
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
	make -j$TERMUX_MAKE_PROCESSES src/{e,}speak-ng
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/bin/{e,}speak{,-ng}
	cp src/.libs/espeak-ng $TERMUX_PREFIX/bin/espeak
	cp src/.libs/libespeak-ng.so $TERMUX_PREFIX/lib/libespeak-ng.so.1.1.49
}
