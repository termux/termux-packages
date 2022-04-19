TERMUX_PKG_HOMEPAGE=https://github.com/orhun/kermit
TERMUX_PKG_DESCRIPTION="A VTE-based simple and froggy terminal emulator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@AnGelXoG"
TERMUX_PKG_VERSION=3.7
TERMUX_PKG_SRCURL=https://github.com/orhun/kermit/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b45d3403de4c1feb158a468c6067b27f14b99873041113233afb9dce75846ecd
TERMUX_PKG_DEPENDS="libvte"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./kermit
}
