TERMUX_PKG_HOMEPAGE=https://zrok.io/
TERMUX_PKG_DESCRIPTION="An open source sharing solution built on OpenZiti"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2.0.4"
TERMUX_PKG_SRCURL=https://github.com/openziti/zrok/releases/download/v${TERMUX_PKG_VERSION}/source-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4da44266316277b4f4b219dd22098534d273f52b08950fca1b22914aebf6f393
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^v\K2\.\d+\.\d+'

termux_step_configure() {
	:
}

termux_step_make() {
	termux_setup_nodejs
	termux_setup_golang

	for dir in ui agent/agentUi; do
		pushd "$dir"
		npm install
		npm run build
		popd
	done

	export GOPATH="$TERMUX_PKG_BUILDDIR"
	export LDFLAGS="-s -w -X main.VERSION=${TERMUX_PKG_VERSION}"
	go build -o zrok2 ./cmd/zrok2
}

termux_step_make_install() {
	install -Dm700 zrok2 "$TERMUX_PREFIX/bin/zrok2"
}
