TERMUX_PKG_HOMEPAGE='https://krita.org'
TERMUX_PKG_DESCRIPTION='Edit and paint images'
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.0
TERMUX_PKG_SRCURL="https://download.kde.org/stable/krita/${TERMUX_PKG_VERSION}/krita-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=932b6876126f7c629e427ee3d012300c8286b05a184277354b414af641a0f1ed
TERMUX_PKG_DEPENDS="exiv2, ffmpeg, fftw, fontconfig, freetype, fribidi, giflib, gsl, harfbuzz, imath, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kitemmodels, kf6-kitemviews, kf6-kwidgetsaddons, kf6-kwindowsystem, libjpeg-turbo, libpng, libtiff, libunibreak, libwebp, libx11, littlecms, mlt, opencolorio, openexr, openjpeg, qt6-qt5compat, qt6-qtbase, qt6-qtsvg, quazip, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, eigen, extra-cmake-modules, immer, lager, libheif, libjpeg-turbo-static, libjxl, libmypaint, poppler-qt, qt6-qttools, xsimd, zug"
TERMUX_PKG_PYTHON_COMMON_DEPS="sip"
TERMUX_PKG_RECOMMENDS="libheif, libjxl, libmypaint, poppler-qt"
# REMOVED due to using Qt5: kseexpr
# IGNORE these packages first: kimageformats, krita-plugin-gmic, pyqt6
# REMOVED from RECOMMENDS: kcrash
# REMOVED from RECOMMENDS: kimageformats, krita-plugin-gmic
# REMOVED from BUILD_DEPS: kdoctools5, pyqt5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_TESTING=OFF
-DBUILD_WITH_QT6=ON
-DTIFF_CAN_WRITE_PSD_TAGS=OFF
"
# -DBUILD_KRITA_QT_DESIGNER_PLUGINS=ON

# needed only when qt5-qtbase is also installed in the system and causing -I$TERMUX_PREFIX/include overriding -isystem $TERMUX_PREFIX/include/qt6.
termux_step_pre_configure() {
	CFLAGS="-I$TERMUX_PREFIX/include/qt6 -I$TERMUX_PREFIX/include/qt6/QtCore5Compat $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/qt6 -I$TERMUX_PREFIX/include/qt6/QtCore5Compat $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/qt6 -I$TERMUX_PREFIX/include/qt6/QtCore5Compat $CXXFLAGS"
}
