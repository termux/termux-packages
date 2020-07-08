TERMUX_PKG_HOMEPAGE=https://chezmoi.io
TERMUX_PKG_DESCRIPTION="Manage your dotfiles across multiple machines"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.8.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/twpayne/chezmoi/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7844371ae748eda0e8432766345dbea718a5fb521d5f6e8fe7d8948935b1947b

termux_step_make_install() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/twpayne"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/twpayne/chezmoi"
	cd "${GOPATH}/src/github.com/twpayne/chezmoi"

	go get -d -v
	go build
	install -Dm700 -t $TERMUX_PREFIX/bin/ ${GOPATH}/src/github.com/twpayne/chezmoi/chezmoi

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
