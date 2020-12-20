TERMUX_PKG_HOMEPAGE=https://www.gpsbabel.org/
TERMUX_PKG_DESCRIPTION="GPS file conversion plus transfer to/from GPS units"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# 1.4.4 is the last version that does not require Qt dependency.
TERMUX_PKG_VERSION=1.4.4
TERMUX_PKG_SRCURL=https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=22860e913f093aa9124e295d52d1d4ae1afccaa67ed6bed6f1f8d8b0a45336d1
TERMUX_PKG_DEPENDS="libexpat"

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+=/gpsbabel
}
