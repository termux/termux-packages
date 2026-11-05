TERMUX_PKG_HOMEPAGE=https://github.com/swaywm/sway
TERMUX_PKG_DESCRIPTION="i3-compatible Wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12"
TERMUX_PKG_SRCURL=https://github.com/swaywm/sway/releases/download/$TERMUX_PKG_VERSION/sway-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a7b1becc217433c11c6284d36bcea0687b87b77b0ed26a384565292ec321f2b1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, json-c, libandroid-wordexp, libcairo, libevdev, libwayland, pango, pcre2, wlroots (>= 0.20.0)"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, libwayland-cross-scanner, scdoc"
TERMUX_PKG_RECOMMENDS="xwayland"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dman-pages=enabled
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper

	# XXX: use alloca for shm_open
	export CPPFLAGS+=" -Wno-alloca -Wno-deprecated-declarations"
	export LDFLAGS+=" -landroid-wordexp"
}
