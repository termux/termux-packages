TERMUX_PKG_HOMEPAGE=https://github.com/DanielSWolf/rhubarb-lip-sync
TERMUX_PKG_DESCRIPTION="Command-line tool that automatically creates 2D mouth animation from voice recordings"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.0"
TERMUX_PKG_SRCURL="https://github.com/DanielSWolf/rhubarb-lip-sync/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=45acd039782c26f563a331f59769a5be7e0f6f337d8ee99f0cfd8a10da40ccdf
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_MAKE_ARGS="rhubarb"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/libexec/rhubarb-lip-sync"
	install -Dm755 "$TERMUX_PKG_BUILDDIR/rhubarb/rhubarb" "$TERMUX_PREFIX/libexec/rhubarb-lip-sync/rhubarb"
	cp -r "$TERMUX_PKG_BUILDDIR/rhubarb/res" "$TERMUX_PREFIX/libexec/rhubarb-lip-sync/"
	cp -r "$TERMUX_PKG_SRCDIR/extras" "$TERMUX_PREFIX/libexec/rhubarb-lip-sync/"

	ln -sf ../libexec/rhubarb-lip-sync/rhubarb "$TERMUX_PREFIX/bin/rhubarb"

	mkdir -p "$TERMUX_PREFIX/share/doc/rhubarb-lip-sync"
	cp -r "$TERMUX_PKG_SRCDIR"/{README.adoc,LICENSE.md,CHANGELOG.md} "$TERMUX_PREFIX/share/doc/rhubarb-lip-sync/"
}
