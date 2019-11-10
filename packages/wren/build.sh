TERMUX_PKG_HOMEPAGE=http://wren.io/
TERMUX_PKG_DESCRIPTION="Small, fast, class-based concurrent scripting language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/wren-lang/wren/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ebf8687dfdb55997a3fc263d41f306c6f40d9562ccbd945d9c12c48795388eae
TERMUX_PKG_DEPENDS="libuv"
TERMUX_PKG_BREAKS="wren-dev"
TERMUX_PKG_REPLACES="wren-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_SRCDIR"/bin/wren \
		"$TERMUX_PREFIX"/bin/wren

	install -Dm600 "$TERMUX_PKG_SRCDIR"/src/include/wren.h \
		"$TERMUX_PREFIX"/include/wren.h

	install -Dm600 "$TERMUX_PKG_SRCDIR"/lib/libwren.so \
		"$TERMUX_PREFIX"/lib/libwren.so
}
