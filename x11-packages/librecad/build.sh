TERMUX_PKG_HOMEPAGE='https://www.librecad.org/'
TERMUX_PKG_DESCRIPTION='A 2D CAD drawing tool based on the community edition of QCad'
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.2a1
TERMUX_PKG_SRCURL="git+https://github.com/LibreCAD/LibreCAD"
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libmuparser, libxcb, qt6-qt5compat, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="boost, imagemagick, librsvg, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"

termux_step_make_install() {
	install -Dm555 -t $TERMUX_PREFIX/bin librecad
	install -Dm444 -t $TERMUX_PREFIX/share/applications $TERMUX_PKG_SRCDIR/desktop/librecad.desktop
	install -Dm644 -t $TERMUX_PREFIX/share/pixmaps $TERMUX_PKG_SRCDIR/librecad/res/main/librecad.png
	install -Dm444 $TERMUX_PKG_SRCDIR/desktop/librecad.sharedmimeinfo $TERMUX_PREFIX/share/mime/packages/librecad.xml
	install -Dm444 "$TERMUX_PKG_SRCDIR/desktop/graphics_icons_and_splash/Icon LibreCAD/Icon_Librecad.svg" $TERMUX_PREFIX/share/icons/hicolor/scalable/apps/librecad.svg
}
