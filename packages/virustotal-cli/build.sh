TERMUX_PKG_HOMEPAGE=https://github.com/VirusTotal/vt-cli
TERMUX_PKG_DESCRIPTION="Command line interface for VirusTotal"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SRCURL=https://github.com/VirusTotal/vt-cli/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=88ef4d2c7708be1bc27c2290181996b6c18e08d5f56a8765de8a5ec13f68e6ac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="vt-cli"
TERMUX_PKG_REPLACES="vt-cli"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/VirusTotal
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/VirusTotal/vt-cli

	cd "$GOPATH"/src/github.com/VirusTotal/vt-cli

	go build \
		-ldflags "-X github.com/VirusTotal/vt-cli/cmd.Version=$TERMUX_PKG_VERSION" \
		-o "$TERMUX_PREFIX"/bin/vt-cli \
		./vt/main.go
}

termux_step_make_install() {
	ln -sfr "$TERMUX_PREFIX"/bin/vt-cli "$TERMUX_PREFIX"/bin/vt
}
