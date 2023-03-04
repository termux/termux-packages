TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Open source multimedia framework"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.1
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cd3ca759f926763615fdfcea63c9761198c42889bc0615ceec73e22b24fde771
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="gstreamer-dev"
TERMUX_PKG_REPLACES="gstreamer-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dcheck=disabled
-Dtests=disabled
-Dexamples=disabled
-Dbenchmarks=disabled
-Dlibunwind=disabled
-Dlibdw=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
}
