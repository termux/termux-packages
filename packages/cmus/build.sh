TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_VERSION=2.7.1
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, libflac, libmad, libvorbis, opusfile, libcue, libpulseaudio"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LD=$CC
	export CONFIG_OSS=n
}

termux_step_configure () {
	./configure prefix=$TERMUX_PREFIX
}
termux_step_post_make_install () {
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		SYSTEM_LIBFOLDER=lib
	else
		SYSTEM_LIBFOLDER=lib64
	fi
	local CMUS_LIBS="" lib
        for lib in FLAC mad cue vorbisfile opusfile  ; do
                if [ -n "$CMUS_LIBS" ]; then CMUS_LIBS+=":"; fi
                CMUS_LIBS+="$TERMUX_PREFIX/lib/lib${lib}.so"
        done
        echo "export LD_PRELOAD=$CMUS_LIBS" >> $TERMUX_PREFIX/bin/cmus

        echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIBFOLDER:/system/vendor/$SYSTEM_LIBFOLDER:$TERMUX_PREFIX/lib $TERMUX_PREFIX/libexec/mpv \"\$@\"" >> $TERMUX_PREFIX/bin/cmus

        chmod +x $TERMUX_PREFIX/bin/cmus
}
