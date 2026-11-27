TERMUX_PKG_HOMEPAGE=https://vale.sh
TERMUX_PKG_DESCRIPTION="A syntax-aware linter for prose built with speed and extensibility in mind"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.29.0"
TERMUX_PKG_SRCURL=https://github.com/errata-ai/vale/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=68bbb94af847e32bc14725e61cf0b5319521960cce6f70c2a21872e9a903e9aa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy

	cp -r "$(go list -m -f '{{.Dir}}' github.com/jdkato/rstgo)" "$TERMUX_PKG_SRCDIR/rstgo"
	chmod -R u+w "$TERMUX_PKG_SRCDIR/rstgo"
	patch -p1 -d "$TERMUX_PKG_SRCDIR/rstgo" < "$TERMUX_PKG_BUILDER_DIR/rstgo-32bit.diff"
	go mod edit -replace github.com/jdkato/rstgo=./rstgo
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"/cmd/vale
	go build -o vale -ldflags="-s -w -X 'main.version=${TERMUX_PKG_VERSION}'"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/cmd/vale/vale
}
