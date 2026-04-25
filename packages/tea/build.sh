TERMUX_PKG_HOMEPAGE=https://gitea.com/gitea/tea
TERMUX_PKG_DESCRIPTION="The official CLI for Gitea"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitea.com/gitea/tea/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f509de217ac0e57491ffdab2750516e8c505780881529ee703b9d0c86cc652a3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"
	go mod vendor
	go build -o tea
	mv tea "$TERMUX_PKG_HOSTBUILD_DIR"/tea
}

termux_step_make() {
	termux_setup_golang

	go mod vendor

	local SDK_VER=$(go list -f '{{.Version}}' -m code.gitea.io/sdk/gitea)
	go build \
		-ldflags "-X 'code.gitea.io/tea/modules/version.Version=${TERMUX_PKG_VERSION}' -X 'code.gitea.io/tea/modules/version.SDK=${SDK_VER}'" \
		-o tea
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin ./tea

	mkdir -p "$TERMUX_PREFIX"/share/bash-completion/completions
	"$TERMUX_PKG_HOSTBUILD_DIR"/tea completion bash > \
		"$TERMUX_PREFIX"/share/bash-completion/completions/tea

	mkdir -p "$TERMUX_PREFIX"/share/zsh/site-functions
	"$TERMUX_PKG_HOSTBUILD_DIR"/tea completion zsh > \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_tea

	mkdir -p "$TERMUX_PREFIX"/share/fish/vendor_completions.d
	"$TERMUX_PKG_HOSTBUILD_DIR"/tea completion fish > \
		"$TERMUX_PREFIX"/share/fish/vendor_completions.d/tea.fish

	mkdir -p "$TERMUX_PREFIX"/share/man/man8
	"$TERMUX_PKG_HOSTBUILD_DIR"/tea man --out "$TERMUX_PREFIX"/share/man/man8/tea.8
}
