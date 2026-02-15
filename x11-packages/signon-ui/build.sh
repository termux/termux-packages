TERMUX_PKG_HOMEPAGE="https://gitlab.com/accounts-sso/signon-ui"
TERMUX_PKG_DESCRIPTION="UI component responsible for handling the user interactions which can happen during the login process of an online account"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17+git20231016"
TERMUX_PKG_SRCURL="git+https://gitlab.com/accounts-sso/signon-ui.git"
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="glib, libc++, libaccounts-qt, libnotify, libproxy, qt6-qtbase, qt6-qtdeclarative, qt6-qtpositioning, qt6-qtwebengine, signond"
TERMUX_PKG_EXCLUDED_ARCHES="i686"

termux_step_pre_configure() {
	export PKG_CONFIG_SYSROOT_DIR="$TERMUX__ROOTFS"
}

termux_step_configure() {
	pushd "${TERMUX_PKG_SRCDIR}"
	# note: 'host-qmake6' appears to correctly set some necessary build settings,
	# such as '-Wl,-rpath,/data/data/com.termux/files/usr/lib'
	# and '-I/data/data/com.termux/files/usr/include/qt6/QtCore',
	# but fails to correctly set some other necessary build settings,
	# like 'aarch64-linux-android-clang++' and '-L/data/data/com.termux/files/usr/lib',
	# so this overrides only the settings that are absolutely necessary to correct,
	# while leaving other settings as they are.
	# also, it's unclear how to successfully pass more than one argument at a time
	# to variables like QMAKE_CXXFLAGS.
	"${TERMUX_PREFIX}/lib/qt6/bin/host-qmake6" \
		QMAKE_CXX="$CXX" \
		QMAKE_LINK="$CXX" \
		QMAKE_CXXFLAGS="-isystem$TERMUX__PREFIX__INCLUDE_DIR" \
		QMAKE_LFLAGS="-L$TERMUX__PREFIX__LIB_DIR" \
		PREFIX="$TERMUX__PREFIX"
	popd
}
