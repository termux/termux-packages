TERMUX_PKG_HOMEPAGE=https://www.lunabase.org/~faber/Vault/software/grap/
TERMUX_PKG_DESCRIPTION="Language for typesetting graphs"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666 <xingguangcuican666@foxmail.com>"
TERMUX_PKG_VERSION="1.49"
TERMUX_PKG_SRCURL="https://www.lunabase.org/~faber/Vault/software/grap/grap-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f0bc7f09641a5ec42f019da64b0b2420d95c223b91b3778ae73cb68acfdf4e23
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/grap/CHANGES
share/doc/grap/COPYRIGHT
share/doc/grap/README
share/doc/grap/grap.man
"

termux_step_pre_configure() {
	autoreconf -fi
}
