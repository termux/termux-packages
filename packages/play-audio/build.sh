TERMUX_PKG_HOMEPAGE=https://github.com/termux/play-audio
TERMUX_PKG_DESCRIPTION="Simple commandline audio player for Android"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/termux/play-audio/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e114123c4b337cddb1d4aa6c3287574d8c81b2dc4b3abc07ce21616fa14f9e82
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	local LIBEXEC_BINARY=$TERMUX_PREFIX/libexec/play-audio
	local BIN_BINARY=$TERMUX_PREFIX/bin/play-audio
	mv $BIN_BINARY $LIBEXEC_BINARY

	cat << EOF > $BIN_BINARY
#!/bin/sh

# Avoid linker errors due to libOpenSLES.so:
LD_PRELOAD=$TERMUX_PREFIX/lib/libc++_shared.so LD_LIBRARY_PATH= exec $LIBEXEC_BINARY "\$@"
EOF

	chmod +x $BIN_BINARY
}
