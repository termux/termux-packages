TERMUX_PKG_HOMEPAGE=https://geth.ethereum.org/
TERMUX_PKG_DESCRIPTION="Go implementation of the Ethereum protocol"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.20"
TERMUX_PKG_SRCURL=https://github.com/ethereum/go-ethereum/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=15ff54f0a4444eb9faa7c1f6219d3a1db5d547178b4eef6679bb601abc681f9d
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "${GOPATH}"/src/github.com/ethereum
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/ethereum/go-ethereum

	cd "$GOPATH"/src/github.com/ethereum/go-ethereum
	for applet in geth abigen bootnode ethkey evm rlpdump puppeth; do
		(cd ./cmd/"$applet" && go build -v)
	done
	unset applet
}

termux_step_make_install() {
	for applet in geth abigen bootnode ethkey evm rlpdump puppeth; do
		install -Dm700 \
			"$TERMUX_PKG_SRCDIR/cmd/$applet/$applet" \
			"$TERMUX_PREFIX"/bin/
	done
	unset applet
}
