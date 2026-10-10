TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/oath-toolkit/
TERMUX_PKG_DESCRIPTION="One-time password components"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.14"
TERMUX_PKG_SRCURL=http://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8b1da365759f1249be57a82aec6e107f7b57dc77d813f96dc0aaf81624f28971
TERMUX_PKG_DEPENDS="libxml2, xmlsec"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="oathtool-dev"
TERMUX_PKG_REPLACES="oathtool-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pam"

termux_step_post_configure() {
	# Fix out-of-tree build
	local _dir _gdoc
	for _dir in libpskc liboath; do
		_gdoc="./${_dir}/man/gdoc"
		if [ ! -e "${_gdoc}" ]; then
			ln -sf "$TERMUX_PKG_SRCDIR/${_dir}/man/gdoc" "${_gdoc}"
		fi
	done

	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libpskc/libtool
}
