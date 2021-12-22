TERMUX_PKG_HOMEPAGE=https://hub.github.com/
TERMUX_PKG_DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/github/hub/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e19e0fdfd1c69c401e1c24dd2d4ecf3fd9044aa4bd3f8d6fd942ed1b2b2ad21a
TERMUX_PKG_AUTO_UPDATE=true
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
