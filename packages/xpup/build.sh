TERMUX_PKG_HOMEPAGE=https://github.com/ericchiang/xpup
TERMUX_PKG_DESCRIPTION="command line tool for processing XML"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.0.0-20150709172731
_COMMIT=8b964504de6fe798bfcdfb0e5303517342ceab42
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SRCURL=https://github.com/ericchiang/xpup.git

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/ericchiang/"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ericchiang/xpup"
	cd "${GOPATH}/src/github.com/ericchiang/xpup"

	go mod init
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/ericchiang/xpup/xpup
}
