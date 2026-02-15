TERMUX_PKG_HOMEPAGE=https://termux.dev
TERMUX_PKG_DESCRIPTION="Termux's ICD/WSI wrapper for using with proprietary Android drivers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.1"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_DEPENDS="libglvnd, libxcb, libx11"
TERMUX_PKG_NO_STRIP=true

TERMUX_PKG_SRCDIR="$TERMUX_PREFIX/opt/termux-wsi-layer/src"

termux_step_pre_configure() {
	mkdir -p "$TERMUX_PREFIX/opt/termux-wsi-layer/src"
	cp -r "${TERMUX_PKG_BUILDER_DIR}/"{*.c,*.h,*.json,CMakeLists.txt} "$TERMUX_PREFIX/opt/termux-wsi-layer/src"
}
