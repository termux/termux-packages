TERMUX_PKG_HOMEPAGE=https://github.com/swaywm/sway
TERMUX_PKG_DESCRIPTION="i3-compatible Wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_SRCURL=https://github.com/swaywm/sway/releases/download/$TERMUX_PKG_VERSION/sway-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=73f08fd2cf7948e8af900709efe44eae412ae11c5773960e25c9aa09f73bad41
TERMUX_PKG_DEPENDS="gdk-pixbuf, json-c, libandroid-wordexp, libcairo, libevdev, libwayland, pango, pcre2, wlroots"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols"
TERMUX_PKG_RECOMMENDS="xwayland"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dxwayland=enabled
"

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"

	# XXX: use alloca for shm_open
	export CPPFLAGS+=" -Wno-alloca"
    export LDFLAGS+=" -landroid-wordexp"
}
