TERMUX_PKG_HOMEPAGE=https://kid3.kde.org/
TERMUX_PKG_DESCRIPTION="Efficient ID3 tag editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/kid3/kid3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=69e3ed1a428c113d90bcbe6187ff9d4d79176d9929a4368a65feeffa1ea2e0a6
TERMUX_PKG_DEPENDS="chromaprint, ffmpeg, id3lib, libc++, libflac, libogg, libvorbis, qt5-qtbase, qt5-qtdeclarative, qt5-qtmultimedia, readline, taglib"
TERMUX_PKG_BUILD_DEPENDS="docbook-xsl, qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
-DWITH_APPS=Qt;CLI
-DWITH_FFMPEG=ON
"

termux_step_post_get_source() {
	# I don't want to make a patch for this:
	find . -name CMakeLists.txt -o -name '*.cmake' | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]ANDROID\)\([^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]ANDROID\)$/\1_NO_TERMUX/g'
}

termux_step_pre_configure() {
	local DOCBOOK_XSL_VER=$(bash -c ". $TERMUX_SCRIPTDIR/packages/docbook-xsl/build.sh; echo \$TERMUX_PKG_VERSION")
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWITH_DOCBOOKDIR=$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-${DOCBOOK_XSL_VER}"

	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/kid3"
}
