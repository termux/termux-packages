TERMUX_PKG_HOMEPAGE=https://github.com/jtyr/gbt
TERMUX_PKG_DESCRIPTION="Highly configurable prompt builder for Bash and ZSH written in Go"
TERMUX_PKG_VERSION=1.1.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jtyr/gbt/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9a4edee1e6901dc07a43b9440e4ca680d0aa241b9d3a0d49c1d0e2a206afa929

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	export GOPATH=$HOME/go
	mkdir -p $GOPATH/{bin,pkg,src/github.com/jtyr}
	ln -fs $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/jtyr/gbt

	go build -ldflags='-s -w' -o $TERMUX_PREFIX/bin/gbt github.com/jtyr/gbt/cmd/gbt

	mkdir -p $TERMUX_PREFIX/{doc/gbt,share/gbt}
	cp -r $TERMUX_PKG_SRCDIR/{sources,themes} $TERMUX_PREFIX/share/gbt/
	cp -r $TERMUX_PKG_SRCDIR/{LICENSE,README.md} $TERMUX_PREFIX/doc/gbt/
}
