TERMUX_PKG_HOMEPAGE=https://hub.github.com/
TERMUX_PKG_DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.13.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/github/hub/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b5147a25aa8dff37d6c88b2a30ed38c05d35e03c64d79039925dcb49de80940
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_golang

	mkdir ./gopath
	export GOPATH="$PWD/gopath"
	mkdir -p "${GOPATH}/src/github.com/github"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/github/hub"

	cd "${GOPATH}/src/github.com/github/hub"
	make man-pages
}

termux_step_make_install() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/github"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/github/hub"
	cd "${GOPATH}/src/github.com/github/hub"
	make bin/hub "prefix=$TERMUX_PREFIX"
	install -Dm700 ./bin/hub "$TERMUX_PREFIX"/bin/hub

	install -D -m 600 -t "$TERMUX_PREFIX"/share/man/man1 \
		"$TERMUX_PKG_HOSTBUILD_DIR"/gopath/src/github.com/github/hub/share/man/man1/*.1
}
