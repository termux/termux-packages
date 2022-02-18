TERMUX_PKG_HOMEPAGE=https://github.com/ggerganov/imtui
TERMUX_PKG_DESCRIPTION="An immediate mode text-based user interface library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE, third-party/imgui/imgui/LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_SRCURL=https://github.com/ggerganov/imtui.git
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"

termux_step_post_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/hnterm
}
