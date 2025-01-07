TERMUX_PKG_HOMEPAGE=https://github.com/swaywm/sway
TERMUX_PKG_DESCRIPTION="i3-compatible Wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10"
TERMUX_PKG_SRCURL=https://github.com/swaywm/sway/releases/download/$TERMUX_PKG_VERSION/sway-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7472a7f11150212e0bed0bd0af9f591c9caac9f9ea87c35486e475a21f5ce81f
TERMUX_PKG_DEPENDS="gdk-pixbuf, json-c, libandroid-wordexp, libcairo, libevdev, libwayland, pango, pcre2, wlroots (>= 0.18.1)"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols"
TERMUX_PKG_RECOMMENDS="xwayland"

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"

	# XXX: use alloca for shm_open
	export CPPFLAGS+=" -Wno-alloca"
	export LDFLAGS+=" -landroid-wordexp"
}
