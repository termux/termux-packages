TERMUX_PKG_HOMEPAGE=https://github.com/jtyr/gbt
TERMUX_PKG_DESCRIPTION="Highly configurable prompt builder for Bash and ZSH written in Go"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/jtyr/gbt/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b324695dc432e8e22bc257f7a6ec576f482ec418fb9c9a8301f47bfdf7766998
TERMUX_PKG_AUTO_UPDATE=true
_COMMIT=29dc3dac6c06518073a8e879d2b6ec65291ddab2

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	termux_setup_golang

	export GOPATH=$HOME/go
	mkdir -p $GOPATH/{bin,pkg,src/github.com/jtyr}
	ln -fs $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/jtyr/gbt

	go mod init gbt
	go mod tidy
	go build -ldflags="-s -w -X main.version=$TERMUX_PKG_VERSION -X main.build=${_COMMIT::6}" -o $TERMUX_PREFIX/bin/gbt github.com/jtyr/gbt/cmd/gbt

	mkdir -p $TERMUX_PREFIX/{doc/gbt,share/gbt}
	cp -r $TERMUX_PKG_SRCDIR/{sources,themes} $TERMUX_PREFIX/share/gbt/
	cp -r $TERMUX_PKG_SRCDIR/{LICENSE,README.md} $TERMUX_PREFIX/doc/gbt/
}
