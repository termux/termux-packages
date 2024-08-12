TERMUX_PKG_HOMEPAGE=https://github.com/FiloSottile/age
TERMUX_PKG_DESCRIPTION="A simple, modern and secure encryption tool with small explicit keys, no config options, and UNIX-style composability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.2.0
TERMUX_PKG_SRCURL=https://github.com/FiloSottile/age/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SHA256=cefe9e956401939ad86a9c9d7dcf843a43b6bcdf4ee7d8e4508864f227a3f6f0

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR
	go build ./cmd/age
	go build ./cmd/age-keygen
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin \
		"${TERMUX_PKG_SRCDIR}"/age \
		"${TERMUX_PKG_SRCDIR}"/age-keygen
}
