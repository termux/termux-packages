TERMUX_PKG_HOMEPAGE=https://gitea.com/gitea/tea
TERMUX_PKG_DESCRIPTION="The official CLI for Gitea"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.1"
TERMUX_PKG_SRCURL=https://gitea.com/gitea/tea/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1da6b6d2534bd6ffb0931400014bbdef26242cf4d35d4ba44c24928811825805
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
