TERMUX_PKG_HOMEPAGE=http://www.daidouji.com/oneko
TERMUX_PKG_DESCRIPTION="oneko-sakurais modified version of oneko, KINOMOTO Sakura chases around your mouse cursor"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.sakura.6"
TERMUX_PKG_SRCURL=git+https://github.com/tie/oneko
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libx11,libxext,xorgproto"
TERMUX_CMAKE_BUILD="Unix Makefiles"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/oneko
}
