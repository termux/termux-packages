TERMUX_PKG_HOMEPAGE=https://github.com/termux/play-audio
TERMUX_PKG_DESCRIPTION="Simple commandline audio player for Android"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_SRCURL=https://github.com/termux/play-audio/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95d495d2692b4ac13b5d0c9f680410f0c08e563ea67ae8de0089c7d9366fa223
TERMUX_PKG_FOLDERNAME=play-audio-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install () {
	local LIBEXEC_BINARY=$TERMUX_PREFIX/libexec/play-audio
	local BIN_BINARY=$TERMUX_PREFIX/bin/play-audio
	mv $BIN_BINARY $LIBEXEC_BINARY

	cat << EOF > $BIN_BINARY
#!/bin/sh

# Avoid linker errors due to libOpenSLES.so:
LD_LIBRARY_PATH= exec $LIBEXEC_BINARY "\$@"
EOF

	chmod +x $BIN_BINARY
}
