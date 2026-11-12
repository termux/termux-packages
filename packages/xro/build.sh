TERMUX_PKG_HOMEPAGE=https://ultraxas.com
TERMUX_PKG_DESCRIPTION="Xro 8.6 autonomous AI coding agent CLI by ULTRAXAS"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="ULTRAXAS <contact@ultraxas.com>"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL="https://ultraxas.com/termux/xro-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5b53fb8f5fea968e7250e7c51e8e78e4fdca2501079257527281f138f35aa539
TERMUX_PKG_DEPENDS="bun"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -d "$TERMUX_PREFIX/lib/xro"
	cp -a lib/. "$TERMUX_PREFIX/lib/xro/"
	install -Dm644 LICENSE "$TERMUX_PREFIX/share/doc/xro/LICENSE"

	cat > "$TERMUX_PREFIX/bin/xro" <<-EOF
		#!${TERMUX_PREFIX}/bin/sh
		exec bun "${TERMUX_PREFIX}/lib/xro/index.js" "\$@"
	EOF
	chmod 755 "$TERMUX_PREFIX/bin/xro"
}
