TERMUX_PKG_HOMEPAGE=https://github.com/FiloSottile/age
TERMUX_PKG_DESCRIPTION="A simple, modern and secure encryption tool with small explicit keys, no config options, and UNIX-style composability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0-beta6
TERMUX_PKG_SRCURL=https://github.com/FiloSottile/age/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=40cb04ecb0d36ae1007bb15339e731ba8ea86277cf704629a5d3d35744452012

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
