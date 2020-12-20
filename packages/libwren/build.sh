TERMUX_PKG_HOMEPAGE=https://wren.io/
TERMUX_PKG_DESCRIPTION="Small, fast, class-based concurrent scripting language libraries"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/wren-lang/wren/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c566422b52a18693f57b15ae4c9459604e426ea64eddb5fbf2844d8781aa4eb7
TERMUX_PKG_BREAKS="wren-dev, wren (<< 0.3.0)"
TERMUX_PKG_REPLACES="wren-dev, wren (<< 0.3.0)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

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
	install -Dm600 "$TERMUX_PKG_SRCDIR"/src/include/wren.h \
		"$TERMUX_PREFIX"/include/wren.h

	install -Dm600 "$TERMUX_PKG_SRCDIR"/lib/libwren.so \
		"$TERMUX_PREFIX"/lib/libwren.so

	install -Dm600 "$TERMUX_PKG_SRCDIR"/lib/libwren.a \
		"$TERMUX_PREFIX"/lib/libwren.a
}
