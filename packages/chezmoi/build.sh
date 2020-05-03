TERMUX_PKG_HOMEPAGE=https://chezmoi.io
TERMUX_PKG_DESCRIPTION="Manage your dotfiles across multiple machines"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SRCURL=https://github.com/twpayne/chezmoi/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b55289372b0e419d9e759f3193cca366a0ae1de2bd72f523d49a0e8ca8567a47

termux_step_make_install() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/twpayne"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/twpayne/chezmoi"
	cd "${GOPATH}/src/github.com/twpayne/chezmoi"
	go install

	install -Dm700 $TERMUX_PKG_BUILDDIR/bin/*/chezmoi $TERMUX_PREFIX/bin/

	mkdir -p $TERMUX_PREFIX/share/bash-completions \
		$TERMUX_PREFIX/share/fish/completions \
		$TERMUX_PREFIX/share/doc/chezmoi

	install ${GOPATH}/src/github.com/twpayne/chezmoi/completions/chezmoi-completion.bash \
		$TERMUX_PREFIX/share/bash-completions/chezmoi
	install ${GOPATH}/src/github.com/twpayne/chezmoi/completions/chezmoi.fish \
		$TERMUX_PREFIX/share/fish/completions/chezmoi.fish

	install ${GOPATH}/src/github.com/twpayne/chezmoi/docs/{FAQ,HOWTO,QUICKSTART,REFERENCE}.md \
		$TERMUX_PREFIX/share/doc/chezmoi/
}
