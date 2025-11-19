TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/oath-toolkit/
TERMUX_PKG_DESCRIPTION="One-time password components"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.12"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cafdf739b1ec4b276441c6aedae6411434bbd870071f66154b909cc6e2d9e8ba
TERMUX_PKG_DEPENDS="libxml2, xmlsec"
TERMUX_PKG_BREAKS="oathtool-dev"
TERMUX_PKG_REPLACES="oathtool-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pam"

termux_step_post_configure() {
	# Fix out-of-tree build
	local _gdoc="./libpskc/man/gdoc"
	if [ ! -e "${_gdoc}" ]; then
		ln -sf "$TERMUX_PKG_SRCDIR/libpskc/man/gdoc" "${_gdoc}"
	fi

	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libpskc/libtool
}
