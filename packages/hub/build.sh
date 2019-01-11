TERMUX_PKG_HOMEPAGE=https://hub.github.com/
TERMUX_PKG_DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
TERMUX_PKG_VERSION=2.7.0
TERMUX_PKG_SHA256=58d131c32404c963b06bcc067bda14317bc22be26187026a91960aecda324bf4
TERMUX_PKG_SRCURL=https://github.com/github/hub/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="git"

termux_step_make_install() {
	termux_setup_golang

	cd $TERMUX_PKG_SRCDIR

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/github"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/github/hub"
	cd "${GOPATH}/src/github.com/github/hub"
	make bin/hub prefix=$TERMUX_PREFIX
	cp ./bin/hub $TERMUX_PREFIX/bin/hub
}
