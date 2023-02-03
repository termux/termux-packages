TERMUX_PKG_HOMEPAGE=https://github.com/ericchiang/pup
TERMUX_PKG_DESCRIPTION="command line tool for processing HTML"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/ericchiang/pup/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/ericchiang/"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ericchiang/pup"
	cd "${GOPATH}/src/github.com/ericchiang/pup"
	export GO111MODULE=off

	go get -d -v
	go build
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/ericchiang/pup/pup
}
