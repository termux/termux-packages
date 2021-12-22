TERMUX_PKG_HOMEPAGE=https://github.com/espeak-ng/espeak-ng
TERMUX_PKG_DESCRIPTION="Compact software speech synthesizer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Use eSpeak NG as the original eSpeak project is dead.
# See https://github.com/espeak-ng/espeak-ng/issues/180
# about cross compilation of espeak-ng.
TERMUX_PKG_VERSION=1.50
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/espeak-ng/espeak-ng/releases/download/$TERMUX_PKG_VERSION/espeak-ng-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_SHA256=80ee6cd06fcd61888951ab49362b400e80dd1fac352a8b1131d90cfe8a210edb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="pcaudiolib"
TERMUX_PKG_BREAKS="espeak-dev"
TERMUX_PKG_REPLACES="espeak-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_RM_AFTER_INSTALL="lib/*ng-test*"
# --without-async due to that using pthread_cancel().
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-async --with-pcaudiolib"

termux_step_post_get_source() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	./autogen.sh
}

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

termux_step_pre_configure() {
	# Oz flag causes problems. See https://github.com/termux/termux-packages/issues/1680:
	CFLAGS=${CFLAGS/Oz/Os}
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
