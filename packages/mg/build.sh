TERMUX_PKG_HOMEPAGE=https://github.com/hboetes/mg
TERMUX_PKG_DESCRIPTION="microscopic GNU Emacs-style editor"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20240709"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/hboetes/mg/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8b2c7574f161172098d6e7feb8a8b7112afbc0604a53cb3a04268e7b32fe45ad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d{8}"
TERMUX_PKG_DEPENDS="libbsd, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# force make
	rm CMakeLists.txt meson.build
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -fcommon"
}
