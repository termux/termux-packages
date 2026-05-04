TERMUX_PKG_HOMEPAGE=https://github.com/hboetes/mg
TERMUX_PKG_DESCRIPTION="microscopic GNU Emacs-style editor"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20260227"
TERMUX_PKG_SRCURL=https://github.com/hboetes/mg/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=21877e912a63c69253538dc8ba6ae3beb1c89f35222e8381d14320f6537cec89
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
