TERMUX_PKG_HOMEPAGE=https://gitea.com/gitea/tea
TERMUX_PKG_DESCRIPTION="The official CLI for Gitea"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL=https://gitea.com/gitea/tea/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=278bbdf2e197f6f80a838e09574e8a950de535f0ba0f53154d26930a3adfaaa6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go mod vendor

	local SDK_VER=$(go list -f '{{.Version}}' -m code.gitea.io/sdk/gitea)
	go build \
		-ldflags "-X 'main.Version=${TERMUX_PKG_VERSION}' -X 'main.SDK=${SDK_VER}'" \
		-o tea
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin ./tea
}
