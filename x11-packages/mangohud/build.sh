TERMUX_PKG_HOMEPAGE=https://github.com/flightlessmango/MangoHud/
TERMUX_PKG_DESCRIPTION="A Vulkan overlay layer for monitoring FPS, temperatures, CPU/GPU load and more"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/flightlessmango/MangoHud/releases/download/v${TERMUX_PKG_VERSION}/MangoHud-v${TERMUX_PKG_VERSION}-Source.tar.xz
TERMUX_PKG_SHA256=4c8d8098f5deff7737978d792eef909b7469933f456a47132dccc06804825482
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libwayland, libx11, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="dbus, libandroid-wordexp, nlohmann-json"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddynamic_string_tokens=false
-Dwith_xnvctrl=disabled
"

termux_step_pre_configure() {
	# Workaround linker error wit version script
	LDFLAGS+=" -Wl,--undefined-version"

	CFLAGS+=" -DRTLD_DEEPBIND=RTLD_NOW"
}
