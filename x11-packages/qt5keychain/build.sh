TERMUX_PKG_HOMEPAGE=https://github.com/frankosterfeld/qtkeychain
TERMUX_PKG_DESCRIPTION="Qt API for storing passwords securely (Qt5)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.1"
TERMUX_PKG_SRCURL="https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=afb2d120722141aca85f8144c4ef017bd74977ed45b80e5d9e9614015dadd60c
TERMUX_PKG_DEPENDS="glib, libc++, libsecret"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DANDROID_NO_TERMUX=OFF
"

termux_step_post_get_source() {
	sed -i CMakeLists.txt \
		-e 's/\<ANDROID\>/ANDROID_NO_TERMUX/g' \
		-e 's/\<Android\>/AndroidNoTermux/g'
}
