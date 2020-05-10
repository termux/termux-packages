TERMUX_PKG_HOMEPAGE=https://cli.github.com/
TERMUX_PKG_DESCRIPTION="GitHub’s official command line tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/cli/cli/archive/v${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SRCURL=https://github.com/cli/cli/archive/v0.7.0.tar.gz
TERMUX_PKG_SHA256=c8966ee2c9fe8138ae7773c66b9a85dd2bfbffc7ca26ce189b294ae0b3e4c05c

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/cli/"
	mkdir -p "$TERMUX_PREFIX/share/doc/gh"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/cli/cli"
	cd "${GOPATH}/src/github.com/cli/cli/cmd/gh"
	go get -d -v
	go build
}

termux_step_make_install() {
	install -Dm700 "$GOPATH/src/github.com/cli/cli/cmd/gh/gh" \
			"$TERMUX_PREFIX/bin"

	install $TERMUX_PKG_SRCDIR/docs/*  \
			"$TERMUX_PREFIX/share/doc/gh"
#
#	install $GOPATH/src/github/cli/cli/docs/gh-vs-hub.md  \ 
#			"$TERMUX_PREFIX/share/doc/"
#
#	install $GOPATH/src/github/cli/cli/docs/releasing.md  \ 
#			"$TERMUX_PREFIX/share/doc/"
#			
#	install $GOPATH/src/github/cli/cli/docs/source.md  \
#			 "$TERMUX_PREFIX/share/doc/"
}
