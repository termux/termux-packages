TERMUX_PKG_HOMEPAGE=https://swagger.io/tools/swagger-codegen/
TERMUX_PKG_DESCRIPTION="Generates API clients, server stubs and docs from OpenAPI definitions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.0.82"
TERMUX_PKG_SRCURL="https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/${TERMUX_PKG_VERSION}/swagger-codegen-cli-${TERMUX_PKG_VERSION}.jar"
TERMUX_PKG_SHA256=b8c18c7e8cf4fbbcd5514144344077e9674962ad80b726095fa7524dfa45e7b6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openjdk-21"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_download \
		"$TERMUX_PKG_SRCURL" \
		"$TERMUX_PKG_CACHEDIR/swagger-codegen-cli-$TERMUX_PKG_VERSION.jar" \
		"$TERMUX_PKG_SHA256"
}

termux_step_make_install() {
	install -Dm644 "$TERMUX_PKG_CACHEDIR/swagger-codegen-cli-$TERMUX_PKG_VERSION.jar" \
		"$TERMUX_PREFIX/share/java/swagger-codegen-cli.jar"

	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" "$TERMUX_PKG_BUILDER_DIR/swagger-codegen.sh" \
		> "$TERMUX_PREFIX/bin/swagger-codegen"
	chmod 755 "$TERMUX_PREFIX/bin/swagger-codegen"
}
