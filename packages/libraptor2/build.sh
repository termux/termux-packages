TERMUX_PKG_HOMEPAGE=https://librdf.org/raptor/
TERMUX_PKG_DESCRIPTION="RDF Syntax Library"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LIB, LICENSE-2.0.txt, LICENSE.txt, NOTICE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.15
TERMUX_PKG_SRCURL=https://download.librdf.org/source/raptor2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ada7f0ba54787b33485d090d3d2680533520cd4426d2f7fb4782dd4a6a1480ed
TERMUX_PKG_DEPENDS="libcurl, libicu, libxml2, libxslt, yajl"
TERMUX_PKG_BUILD_DEPENDS="icu-devtools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-icu-config=icu-config
--with-yajl=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	local bin="$TERMUX_PKG_BUILDDIR/bin"
	local sh="$(which sh)"
	mkdir -p "$bin"
	for p in curl icu xml2 xslt; do
		local conf="$bin/${p}-config"
		cat > "$conf" <<-EOF
			#!${sh}
			exec sh "$TERMUX_PREFIX/${p}-config" "\$@"
		EOF
		chmod 0700 "$conf"
	done
	export PATH="$bin":$PATH
}
