TERMUX_PKG_HOMEPAGE=http://termux.com
TERMUX_PKG_DESCRIPTION="Simple commandline audio player for Android"
TERMUX_PKG_VERSION=0.3

termux_step_make_install () {
	local LIBEXEC_BINARY=$TERMUX_PREFIX/libexec/play-audio
	$CXX $CFLAGS $LDFLAGS \
		-std=c++14 -Wall -Wextra -pedantic -Werror \
		-lOpenSLES \
		$TERMUX_PKG_BUILDER_DIR/play-audio.cpp -o $LIBEXEC_BINARY

	printf "#!/bin/sh\n\n# Avoid linker errors due to libOpenSLES.so:\nLD_LIBRARY_PATH= exec $LIBEXEC_BINARY \"\$@\"\n" > $TERMUX_PREFIX/bin/play-audio
	chmod +x $TERMUX_PREFIX/bin/play-audio

	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_BUILDER_DIR/play-audio.1 $TERMUX_PREFIX/share/man/man1/
}
