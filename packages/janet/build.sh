TERMUX_PKG_HOMEPAGE="https://github.com/janet-lang/janet"
TERMUX_PKG_DESCRIPTION="A dynamic language and bytecode vm"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.23.0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL="https://github.com/janet-lang/janet/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256="0b4d5d3632e0d376d9512ea8ea262f31f75c132b488dd7870f472acae709a865"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_DEPENDS="libandroid-spawn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS='
'
termux_step_pre_configure() {
	export LDFLAGS+=" -landroid-spawn"
	ls -alhF "$TERMUX_PREFIX/lib"
	ls -alhF "$TERMUX_PREFIX/include"
	cat "$TERMUX_PREFIX/include/spawn.h"
    cat $TERMUX_PREFIX/include/spawn.h | grep posix_spawn_file_actions_init
	rm -f "meson.build" "meson_options.txt"
    exit 4
}
