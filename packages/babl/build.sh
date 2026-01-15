TERMUX_PKG_HOMEPAGE=https://gegl.org/babl/
TERMUX_PKG_DESCRIPTION="Dynamic pixel format translation library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.120"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/babl/-/archive/BABL_${TERMUX_PKG_VERSION//./_}/babl-BABL_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=27a5cbdd5e1be74e6763a24c89991462e2f7555bee9a54a39157418cc09bf308
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
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
	cat <<- EOF > "$TERMUX_PKG_SRCDIR/git-version.h"
	#ifndef BABL_GIT_VERSION
	#define BABL_GIT_VERSION "$TERMUX_PKG_VERSION termux"
	#endif
	EOF
}
