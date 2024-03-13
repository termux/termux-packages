TERMUX_PKG_HOMEPAGE=https://github.com/flightlessmango/MangoHud/
TERMUX_PKG_DESCRIPTION="A Vulkan overlay layer for monitoring FPS, temperatures, CPU/GPU load and more"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.1"
TERMUX_PKG_SRCURL=https://github.com/flightlessmango/MangoHud/releases/download/v${TERMUX_PKG_VERSION}/MangoHud-v${TERMUX_PKG_VERSION}-1-Source.tar.xz
TERMUX_PKG_SHA256=cfcc907c91b51f1fef4ec3f1cd52e2ff1b5caf207cdcff71869b94cefe39d208
TERMUX_PKG_DEPENDS="dbus, libx11"
TERMUX_PKG_BUILD_DEPENDS="nlohmann-json"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddynamic_string_tokens=false
-Dwith_xnvctrl=disabled
"

# generate shader files in host system before version update
# glslang -V -x -o overlay.frag.spv.h MangoHud-v${TERMUX_PKG_VERSION}/src/overlay.frag
# glslang -V -x -o overlay.vert.spv.h MangoHud-v${TERMUX_PKG_VERSION}/src/overlay.vert
termux_step_pre_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/overlay.frag.spv.h $TERMUX_PKG_SRCDIR/src/overlay.frag.spv.h
	cp $TERMUX_PKG_BUILDER_DIR/overlay.vert.spv.h $TERMUX_PKG_SRCDIR/src/overlay.vert.spv.h

	# Workaround linker error wit version script
	LDFLAGS+=" -Wl,--undefined-version"
}
