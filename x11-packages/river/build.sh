TERMUX_PKG_HOMEPAGE=https://codeberg.org/ifreund/$TERMUX_PKG_NAME
TERMUX_PKG_DESCRIPTION="A dynamic tiling wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.9
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/releases/download/v$TERMUX_PKG_VERSION/$TERMUX_PKG_NAME-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=49d8a2b679597cf5dff07008a1215892cc05525fb4085b5226b51611666335e5
TERMUX_PKG_BUILD_DEPENDS="libevdev, libpixman, libwayland, wlroots, libxkbcommon, xwayland"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, libwayland-cross-scanner, scdoc, zig-wlroots, zig-pixman, zig-wayland, zig-xkbcommon"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_ZIG_VERSION=0.14.1

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
	termux_setup_zig
}

termux_step_make() {
	zig build --system $TERMUX_PREFIX/lib/zig/packages \
		-Dtarget=$ZIG_TARGET_NAME \
		-Doptimize=ReleaseSafe \
		-Dxwayland
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin zig-out/bin/*
}
