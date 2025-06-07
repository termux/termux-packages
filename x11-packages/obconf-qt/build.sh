TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="OpenBox window manager configuration tool"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.5"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/lxqt/obconf-qt/releases/download/${TERMUX_PKG_VERSION}/obconf-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=034883680912f7ea24dbd4c28b8ee4cf096774aa588e39431d319d56a924160c
TERMUX_PKG_REPLACES="obconf"
TERMUX_PKG_BREAKS="obconf"
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, glib, openbox, liblxqt, hicolor-icon-theme, libxml2"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}

termux_step_post_make_install() {
	ln -sf obconf-qt "$TERMUX_PREFIX"/bin/obconf
}
