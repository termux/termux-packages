TERMUX_PKG_HOMEPAGE=https://librdf.org/raptor/
TERMUX_PKG_DESCRIPTION="RDF Syntax Library"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LIB, LICENSE-2.0.txt, LICENSE.txt, NOTICE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.16
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://download.librdf.org/source/raptor2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=089db78d7ac982354bdbf39d973baf09581e6904ac4c92a98c5caadb3de44680
TERMUX_PKG_DEPENDS="libcurl, libicu, libxml2, libxslt, yajl"
TERMUX_PKG_BUILD_DEPENDS="icu-devtools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-icu-config=icu-config
--with-yajl=$TERMUX_PREFIX
"

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}

termux_step_post_massage() {
	# For backward compatibility. Rebuild revdeps and delete this.
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libraptor2.so.0" ]; then
		ln -sf libraptor2.so libraptor2.so.0
	fi
}
