TERMUX_PKG_HOMEPAGE=http://termux.com
TERMUX_PKG_DESCRIPTION="Simple commandline audio player for Android"
TERMUX_PKG_VERSION=0.4

termux_step_make_install () {
	local LIBEXEC_BINARY=$TERMUX_PREFIX/libexec/play-audio
	# Use $CC instead of $CXX to link in order to avoid linking
	# against libgnustl_shared.so, since the launcher script
	# below removes LD_LIBRARY_PATH.
	$CC $CFLAGS $LDFLAGS \
		-std=c++14 -Wall -Wextra -pedantic -Werror \
		-fno-exceptions \
		-lOpenSLES \
		$TERMUX_PKG_BUILDER_DIR/play-audio.cpp -o $LIBEXEC_BINARY

		cat << EOF > $TERMUX_PREFIX/bin/play-audio
#!/bin/sh

# Avoid linker errors due to libOpenSLES.so:
LD_LIBRARY_PATH= exec $LIBEXEC_BINARY "\$@"
EOF

	chmod +x $TERMUX_PREFIX/bin/play-audio

	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_BUILDER_DIR/play-audio.1 $TERMUX_PREFIX/share/man/man1/
}
