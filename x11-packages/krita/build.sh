TERMUX_PKG_HOMEPAGE='https://krita.org'
TERMUX_PKG_DESCRIPTION='Edit and paint images'
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.0.2.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/krita/${TERMUX_PKG_VERSION}/krita-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=67533cb115dec2a5987b5afa7dd4cf8e0444b907cd99349cf1d0fb64456e40f8
TERMUX_PKG_DEPENDS="exiv2, ffmpeg, fftw, fontconfig, freetype, fribidi, giflib, gsl, harfbuzz, imath, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kitemviews, kf6-kwidgetsaddons, kf6-kcrash, libjpeg-turbo, libkdcraw, libpng, libtiff, libunibreak, libwebp, libx11, libxkbcommon, littlecms, mlt, opencolorio, openexr, openjpeg, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg, quazip, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, eigen, extra-cmake-modules, immer, kseexpr, lager, libheif, libjpeg-turbo-static, libjxl, libmypaint, poppler-qt, qt6-qttools, xsimd, zug"
TERMUX_PKG_RECOMMENDS="kf6-kimageformats, kseexpr, libheif, libjxl, libmypaint, poppler-qt"
# ADD RECOMMENDS: krita-plugin-gmic, pyqt6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DCMAKE_SYSTEM_NAME=Linux
-DALLOW_UNSTABLE=QT6
-DBUILD_TESTING=OFF
-DBUILD_WITH_QT6=ON
-DTIFF_CAN_WRITE_PSD_TAGS=OFF
-DBUILD_KRITA_QT_DESIGNER_PLUGINS=ON
"

termux_step_pre_configure() {
	CFLAGS="-I$TERMUX_PREFIX/include/qt6 -I$TERMUX_PREFIX/include/qt6/QtCore5Compat $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/qt6 -I$TERMUX_PREFIX/include/qt6/QtCore5Compat $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/qt6 -I$TERMUX_PREFIX/include/qt6/QtCore5Compat $CXXFLAGS"
}
