TERMUX_PKG_HOMEPAGE=https://www.aptly.info
TERMUX_PKG_DESCRIPTION="A Swiss Army knife for Debian repository management"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/aptly-dev/aptly/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=07e18ce606feb8c86a1f79f7f5dd724079ac27196faa61a2cefa5b599bbb5bb1
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p "$GOPATH"/src/github.com/aptly-dev/
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/aptly-dev/aptly
	cd "$GOPATH"/src/github.com/aptly-dev/aptly

	go mod tidy
	go mod vendor
	make install VERSION=$TERMUX_PKG_VERSION
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/bin/${GOOS}_${GOARCH}/aptly \
		"$TERMUX_PREFIX"/bin/aptly

	install -Dm600 \
		"$TERMUX_PKG_SRCDIR"/man/aptly.1 \
		"$TERMUX_PREFIX"/share/man/man1/aptly.1
}
