TERMUX_PKG_HOMEPAGE=https://www.getdnote.com/
TERMUX_PKG_DESCRIPTION="A simple command line notebook for programmers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Ravener <ravener.anime@gmail.com>"
TERMUX_PKG_VERSION=1:0.12.0
TERMUX_PKG_SRCURL=https://github.com/dnote/dnote/archive/refs/tags/cli-v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=2b2c276f3b381a853e155ed2eab7007c5b5f2ec927b3d882d5605f2650b15085
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS=dnote-client
TERMUX_PKG_REPLACES=dnote-client

termux_step_pre_configure() {
	termux_setup_golang
	go mod download 
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"
	go build -o dnote -ldflags "-X main.versionTag=${TERMUX_PKG_VERSION:2}" pkg/cli/main.go
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/dnote $TERMUX_PREFIX/bin/dnote
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/dnote.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_dnote"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/dnote.fish"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		dnote completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/dnote.bash
		dnote completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_dnote
		dnote completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/dnote.fish
	EOF
}

termux_step_install_license() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/licenses/GPLv3.txt"
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}" \
		"${TERMUX_PKG_SRCDIR}/LICENSE"
}
