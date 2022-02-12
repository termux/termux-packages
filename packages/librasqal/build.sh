TERMUX_PKG_HOMEPAGE=https://librdf.org/rasqal/
TERMUX_PKG_DESCRIPTION="RDF Query Library"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LIB, LICENSE-2.0.txt, LICENSE.txt, NOTICE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.33
TERMUX_PKG_SRCURL=http://download.librdf.org/source/rasqal-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6924c9ac6570bd241a9669f83b467c728a322470bf34f4b2da4f69492ccfd97c
TERMUX_PKG_DEPENDS="libgmp, libmhash, libraptor2, libuuid, pcre"
TERMUX_PKG_BUILD_DEPENDS="libxml2"

termux_step_pre_configure() {
	local bin="$TERMUX_PKG_BUILDDIR/bin"
	local sh="$(command -v sh)"
	mkdir -p "$bin"
	for p in pcre xml2; do
		local conf="$bin/${p}-config"
		cat > "$conf" <<-EOF
			#!${sh}
			exec sh "$TERMUX_PREFIX/bin/${p}-config" "\$@"
		EOF
		chmod 0700 "$conf"
	done
	export PATH="$bin":$PATH
}
