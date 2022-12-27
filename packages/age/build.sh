TERMUX_PKG_HOMEPAGE=https://github.com/FiloSottile/age
TERMUX_PKG_DESCRIPTION="A simple, modern and secure encryption tool with small explicit keys, no config options, and UNIX-style composability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.1.1
TERMUX_PKG_SRCURL=https://github.com/FiloSottile/age/archive/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=f1f3dbade631976701cd295aa89308681318d73118f5673cced13f127a91178c

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
