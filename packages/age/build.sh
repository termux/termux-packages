TERMUX_PKG_HOMEPAGE=https://github.com/FiloSottile/age
TERMUX_PKG_DESCRIPTION="A simple, modern and secure encryption tool with small explicit keys, no config options, and UNIX-style composability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:1.2.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/FiloSottile/age/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SHA256=93bd89a16c74949ee7c69ef580d8e4cf5ce03e7d9c461b68cf1ace3e4017eef5

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
