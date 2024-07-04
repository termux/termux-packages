TERMUX_PKG_HOMEPAGE=https://docs.iyear.me/tdl/
TERMUX_PKG_DESCRIPTION="Telegram downloader/tools written in Golang"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.2"
TERMUX_PKG_SRCURL=https://github.com/iyear/tdl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=79b171fead97b26ab5b4b643a20a236d634eed46dbcf85cc55ec28ff190a27ea
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin tdl

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/tdl
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_tdl
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/tdl.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		tdl completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/tdl"
		tdl completion zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_tdl"
		tdl completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/tdl.fish"
	EOF
}
