TERMUX_PKG_HOMEPAGE=https://chezmoi.io
TERMUX_PKG_DESCRIPTION="Manage your dotfiles across multiple machines"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION="2.33.1"
TERMUX_PKG_SRCURL=https://github.com/twpayne/chezmoi/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f1d053a65f1fc1b3b4c254462d93466805849c0a0e3b02c43c34846c66a0794
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne"
	cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi"
	cd "${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi"

	go get -d -v
	go build -tags noupgrade,noembeddocs \
		-ldflags "-X github.com/twpayne/chezmoi/cmd.DocsDir=$TERMUX_PREFIX/share/doc/chezmoi -X main.version=${TERMUX_PKG_VERSION}" .
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/chezmoi $TERMUX_PREFIX/bin/chezmoi

	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions \
		$TERMUX_PREFIX/share/fish/completions \
		$TERMUX_PREFIX/share/zsh/site-functions \
		$TERMUX_PREFIX/share/doc/chezmoi

	install -Dm600 ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/completions/chezmoi-completion.bash \
		$TERMUX_PREFIX/share/bash-completion/completions/chezmoi
	install -Dm600 ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/completions/chezmoi.fish \
		$TERMUX_PREFIX/share/fish/vendor_completions.d/chezmoi.fish
	install -Dm600 ${TERMUX_PKG_BUILDDIR}/src/github.com/twpayne/chezmoi/completions/chezmoi.zsh \
		$TERMUX_PREFIX/share/zsh/site-functions/_chezmoi
}
