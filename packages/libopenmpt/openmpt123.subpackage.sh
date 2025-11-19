TERMUX_SUBPKG_DESCRIPTION="libopenmpt based command-line player for tracker music formats"
TERMUX_SUBPKG_DEPENDS="libflac, libsndfile, pulseaudio"
TERMUX_SUBPKG_BREAKS="libopenmpt (<< 0.8.2-1)"
TERMUX_SUBPKG_REPLACES="libopenmpt (<< 0.8.2-1)"
TERMUX_SUBPKG_INCLUDE="
bin/openmpt123
share/man/man1/openmpt123.1.gz
"
