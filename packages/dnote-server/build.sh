TERMUX_PKG_HOMEPAGE=https://www.getdnote.com/
TERMUX_PKG_DESCRIPTION="This package contains the Dnote server. It comprises of the web interface, the web API, and the background jobs."
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/dnote/dnote/archive/refs/tags/server-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=28cc3bf93b3849b9a4a5e65e531f8a34d6be6048427d924c56ab8c7887676bad
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SUGGESTS="postgresql"

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_golang

	go mod download

	# build assets for dnote-server:
	cd "$TERMUX_PKG_SRCDIR/pkg/server/assets"
	npm update && npm i
	./js/build.sh
	./styles/build.sh
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"

	# build binary
	moduleName="github.com/dnote/dnote"
	ldflags="-X '$moduleName/pkg/server/buildinfo.CSSFiles=main.css' -X '$moduleName/pkg/server/buildinfo.JSFiles=main.js' -X '$moduleName/pkg/server/buildinfo.Version=$TERMUX_PKG_VERSION' -X '$moduleName/pkg/server/buildinfo.Standalone=true'"

	go build -o dnote-server -ldflags "$ldflags" pkg/server/main.go
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/dnote-server $TERMUX_PREFIX/bin/dnote-server
}

termux_step_install_license() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/licenses/AGPLv3.txt"
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/LICENSE"
}
