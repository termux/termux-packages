TERMUX_PKG_HOMEPAGE="https://gitlab.com/accounts-sso/signond/"
TERMUX_PKG_DESCRIPTION="A D-Bus service which performs user authentication on behalf of its clients"
TERMUX_PKG_LICENSE="LGPL-2.1-only"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.61"
TERMUX_PKG_SRCURL="https://gitlab.com/accounts-sso/signond/-/archive/VERSION_${TERMUX_PKG_VERSION}/signond-VERSION_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="3dd57c25e1bf1583b2cb857f96831e38e73d40264ff66ca43e63bb7233f76828"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="VERSION_\d+.\d+"
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/VERSION_//"
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools, ttf-dejavu"

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
