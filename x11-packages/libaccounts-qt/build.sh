TERMUX_PKG_HOMEPAGE="https://gitlab.com/accounts-sso/libaccounts-qt"
TERMUX_PKG_DESCRIPTION="Qt-based client library for accessing the online accounts database"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.17"
TERMUX_PKG_SRCURL="https://gitlab.com/accounts-sso/libaccounts-qt/-/archive/VERSION_${TERMUX_PKG_VERSION}/libaccounts-qt-VERSION_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="6ed3e976133962c1c88f6c66928ba0d0a17a570843577d31e783dc891659e5d8"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="VERSION_\d+.\d+"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/VERSION_//"
TERMUX_PKG_DEPENDS="glib, libc++, libaccounts-glib, qt6-qtbase"

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
