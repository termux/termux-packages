TERMUX_PKG_HOMEPAGE=https://github.com/elves/elvish
TERMUX_PKG_DESCRIPTION="A friendly and expressive Unix shell"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.18.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/elves/elvish/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f4635db90af2241bfd37e17ac1a72567b92d18a396598da2099a908b3d88c590

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/elves
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/elves/elvish

	cd "$GOPATH"/src/github.com/elves/elvish/cmd/elvish
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/elves/elvish/cmd/elvish/elvish \
		"$TERMUX_PREFIX"/bin/elvish
}
