TERMUX_PKG_HOMEPAGE=https://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.110"
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/babl/${TERMUX_PKG_VERSION%.*}/babl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bf47be7540d6275389f66431ef03064df5376315e243d0bab448c6aa713f5743
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="littlecms"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_BREAKS="babl-dev"
TERMUX_PKG_REPLACES="babl-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-gir=true
"

termux_step_pre_configure() {
	termux_setup_gir
}
