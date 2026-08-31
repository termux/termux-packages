TERMUX_PKG_HOMEPAGE=https://github.com/mongodb-js/mongosh
TERMUX_PKG_DESCRIPTION="The MongoDB Shell"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.10.0"
TERMUX_PKG_SRCURL=https://github.com/mongodb-js/mongosh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42775a281d2848c98359c952286a0712cc170e6bb1eadc9b2a1470fa3a274b88
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_nodejs
	npm ci --ignore-scripts
	npm install ipv6-normalize --no-save --ignore-scripts
}

termux_step_make() {
	termux_setup_nodejs
	npm run compile-cli
	npm run webpack-build -w packages/cli-repl
}

termux_step_make_install() {
	install -d "$TERMUX_PREFIX/lib/mongosh"
	cp packages/cli-repl/dist/mongosh.js "$TERMUX_PREFIX/lib/mongosh/"

	cat > "$TERMUX_PREFIX/bin/mongosh" <<-EOF
	#!${TERMUX_PREFIX}/bin/sh
	exec node "${TERMUX_PREFIX}/lib/mongosh/mongosh.js" "\$@"
	EOF
	chmod 755 "$TERMUX_PREFIX/bin/mongosh"
}
