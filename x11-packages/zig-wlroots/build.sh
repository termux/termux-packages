TERMUX_PKG_HOMEPAGE=https://codeberg.org/ifreund/$TERMUX_PKG_NAME
TERMUX_PKG_DESCRIPTION="Zig bindings for wlroots"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.18.2
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e3f3061420a031e37afa809a8f467976c6d5a37b3cf28624d7eab498c5eb8fc2
TERMUX_PKG_DEPENDS="wlroots, zig-pixman, zig-wayland, zig-xkbcommon"

termux_step_pre_configure() {
	termux_setup_zig
	ZIG_PKG_HASH=$(zig fetch --global-cache-dir $TERMUX_PKG_BUILDDIR .)
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib/zig/packages/$ZIG_PKG_HASH \
		$TERMUX_PKG_BUILDDIR/p/$ZIG_PKG_HASH/build.zig
	install -Dm600 -t $TERMUX_PREFIX/lib/zig/packages/$ZIG_PKG_HASH \
		$TERMUX_PKG_BUILDDIR/p/$ZIG_PKG_HASH/build.zig.zon
	install -Dm600 -t $TERMUX_PREFIX/lib/zig/packages/$ZIG_PKG_HASH \
		$TERMUX_PKG_BUILDDIR/p/$ZIG_PKG_HASH/LICENSE
	cp -r $TERMUX_PKG_BUILDDIR/p/$ZIG_PKG_HASH/src \
		$TERMUX_PREFIX/lib/zig/packages/$ZIG_PKG_HASH
	find $TERMUX_PREFIX/lib/zig/packages/$ZIG_PKG_HASH/src \
		-type f -exec chmod 0600 {} \;
}
