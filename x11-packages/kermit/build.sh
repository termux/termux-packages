TERMUX_PKG_HOMEPAGE=https://github.com/orhun/kermit
TERMUX_PKG_DESCRIPTION="A VTE-based simple and froggy terminal emulator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@AnGelXoG"
TERMUX_PKG_VERSION=3.8
TERMUX_PKG_SRCURL=https://github.com/orhun/kermit/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7b2ad85f73bccee4f6d890693afae2002ca2c51965b83c42e1ca4f4d980468c8
TERMUX_PKG_DEPENDS="glib, gtk3, libvte, pango"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./kermit
}
