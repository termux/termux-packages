TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/oath-toolkit/
TERMUX_PKG_DESCRIPTION="One-time password components"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.11
TERMUX_PKG_SRCURL=http://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fc512a4a5b46f4c43ab0586c3189fece4d54f7e649397d6fa1e23428431e2cb4
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
