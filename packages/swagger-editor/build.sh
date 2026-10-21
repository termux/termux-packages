TERMUX_PKG_HOMEPAGE=https://swagger.io/tools/swagger-editor/
TERMUX_PKG_DESCRIPTION="Browser-based editor for designing OpenAPI and AsyncAPI definitions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSES/Apache-2.0.txt, NOTICE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="5.9.1"
TERMUX_PKG_SRCURL="https://github.com/swagger-api/swagger-editor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d3d420750f2c29072f61c3dca4038bc6f893cca67852302cc56f83a948c3d53f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_nodejs

	npm ci --ignore-scripts
	# Lifecycle scripts are skipped, so apply the dependency patches by hand
	npx patch-package
	VITE_VERSION="$TERMUX_PKG_VERSION" npm run build:app
}

termux_step_make_install() {
	find build -name '*.map' -delete
	mkdir -p "$TERMUX_PREFIX/share/swagger-editor"
	cp -r build/. "$TERMUX_PREFIX/share/swagger-editor/"

	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "$TERMUX_PKG_BUILDER_DIR/swagger-editor.sh" \
		> "$TERMUX_PREFIX/bin/swagger-editor"
	chmod 755 "$TERMUX_PREFIX/bin/swagger-editor"
}
