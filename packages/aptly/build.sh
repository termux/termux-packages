TERMUX_PKG_HOMEPAGE=https://www.aptly.info
TERMUX_PKG_DESCRIPTION="A Swiss Army knife for Debian repository management"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.2"
TERMUX_PKG_SRCURL=https://github.com/aptly-dev/aptly/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cadfabda2a59f397adfe6f9ce3c9ddc6fe4c6052f0e03a300ba1f22d7cf0e09a
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p "$GOPATH"/src/github.com/aptly-dev/
	cp -a "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/aptly-dev/aptly
	cd "$GOPATH"/src/github.com/aptly-dev/aptly

	go mod tidy
	go mod vendor
	go generate
	go build -ldflags "-s -w" -trimpath -o build/aptly
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/aptly-dev/aptly/build/aptly \
		"$TERMUX_PREFIX"/bin/aptly

	install -Dm600 \
		"$TERMUX_PKG_SRCDIR"/man/aptly.1 \
		"$TERMUX_PREFIX"/share/man/man1/aptly.1

	install -Dm600 \
		"$TERMUX_PKG_SRCDIR"/completion.d/aptly \
		"$TERMUX_PREFIX"/share/bash-completion/completions/aptly

	install -Dm600 \
		"$TERMUX_PKG_SRCDIR"/completion.d/_aptly \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_aptly
}
