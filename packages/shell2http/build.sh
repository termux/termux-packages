TERMUX_PKG_HOMEPAGE=https://github.com/msoap/shell2http
TERMUX_PKG_DESCRIPTION="Executing shell commands via HTTP server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Krishna kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="1.16.0"
TERMUX_PKG_SRCURL=https://github.com/msoap/shell2http/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90aa95c7b7bdb068b5b4a44e3e6782cda6b8417efbd0551383fb4f102e04584c
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/msoap/"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/msoap/shell2http"
	cd "${GOPATH}/src/github.com/msoap/shell2http"
	go get -d -v
	go build -ldflags "-X 'main.version=$TERMUX_PKG_VERSION'"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/msoap/shell2http/shell2http
}
