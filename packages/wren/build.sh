TERMUX_PKG_HOMEPAGE=https://wren.io/
TERMUX_PKG_DESCRIPTION="Small, fast, class-based concurrent scripting language interpreter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://github.com/wren-lang/wren-cli/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fafdc5d6615114d40de3956cd3a255e8737dadf8bd758b48bac00db61563cb4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libuv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	local QUIET_BUILD=
	if [ "$TERMUX_QUIET_BUILD" = true ]; then
		QUIET_BUILD="-s"
	fi

	cd projects/make
	if [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = arm ]; then
		RELEASE=release_32bit
	else
		RELEASE=release_64bit
	fi
	make -j $TERMUX_MAKE_PROCESSES $QUIET_BUILD config=${RELEASE}
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_SRCDIR"/bin/wren_cli \
		"$TERMUX_PREFIX"/bin/wren
}
