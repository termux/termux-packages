TERMUX_PKG_HOMEPAGE=https://github.com/jesseduffield/lazydocker
TERMUX_PKG_DESCRIPTION="A simple terminal UI for both docker and docker-compose"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.25.2"
TERMUX_PKG_SRCURL=https://github.com/jesseduffield/lazydocker/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=405071220e5be9aa061c65d290e0347143b73ae0a3cc01df164f0105de2b53c4
TERMUX_PKG_DEPENDS="docker-cli"
TERMUX_PKG_RECOMMENDS="dockerd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o lazydocker \
		.
}

termux_step_make_install() {
	install -Dm755 lazydocker "$TERMUX_PREFIX/bin/lazydocker"
}

termux_step_create_debscripts() {
	cat >postinst <<-POSTINST_EOF
		#!${TERMUX_PREFIX}/bin/sh
		echo "'lazydocker' requires a preexisting configuration of the real 'docker' package in Termux before it can be used."
	POSTINST_EOF
}
