TERMUX_PKG_HOMEPAGE=https://kid3.kde.org/
TERMUX_PKG_DESCRIPTION="Efficient ID3 tag editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.5"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/kid3/kid3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d68f6e1d7b794b991b57bf976edb8e22d3457911db654ad1fb9b124cc62057f9
TERMUX_PKG_AUTO_UPDATE=true
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
