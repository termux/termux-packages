TERMUX_PKG_HOMEPAGE=https://swagger.io/tools/swagger-ui/
TERMUX_PKG_DESCRIPTION="Web UI for visualizing and interacting with OpenAPI definitions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, NOTICE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="5.34.0"
TERMUX_PKG_SRCURL="https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=55f4773d0dabd9cbfcb80fe0bab8f465607b9ea114142f8fe08a6d5682e244d2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_nodejs

	npm ci --ignore-scripts
	npm run build
}

termux_step_make_install() {
	# Source maps and build logs are not needed at runtime
	find dist -maxdepth 1 -type f ! -name '*.map' ! -name 'log.*' \
		-exec install -Dm644 -t "$TERMUX_PREFIX/share/swagger-ui" {} +

	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "$TERMUX_PKG_BUILDER_DIR/swagger-ui.sh" \
		> "$TERMUX_PREFIX/bin/swagger-ui"
	chmod 755 "$TERMUX_PREFIX/bin/swagger-ui"
}
