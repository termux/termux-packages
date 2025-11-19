TERMUX_PKG_HOMEPAGE=https://github.com/ismaelpadilla/gotorrent
TERMUX_PKG_DESCRIPTION="TUI for searching torrents"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.2
TERMUX_PKG_SRCURL=https://github.com/ismaelpadilla/gotorrent/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=66973b9f1c916315b2e0721b1ceebfce96242b291ba8fc8c039e75728bc2ada5

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"
	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/ismaelpadilla/"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ismaelpadilla/gotorrent"
	cd "${GOPATH}/src/github.com/ismaelpadilla/gotorrent"
	go get -v
	go build -o gotorrent main.go
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$GOPATH"/src/github.com/ismaelpadilla/gotorrent/gotorrent
}
