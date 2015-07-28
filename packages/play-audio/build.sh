TERMUX_PKG_HOMEPAGE=http://termux.com
TERMUX_PKG_DESCRIPTION="Simple commandline audio player for Android"
TERMUX_PKG_VERSION=0.1

termux_step_make_install () {
	$CXX $CFLAGS $LDFLAGS \
		-std=c++14 -Wall -Wextra -pedantic -Werror \
		-lOpenSLES \
		$TERMUX_PKG_BUILDER_DIR/play-audio.cpp -o $TERMUX_PREFIX/bin/play-audio

	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_BUILDER_DIR/play-audio.1 $TERMUX_PREFIX/share/man/man1/
}
