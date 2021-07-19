TERMUX_PKG_HOMEPAGE=https://geth.ethereum.org/
TERMUX_PKG_DESCRIPTION="Go implementation of the Ethereum protocol"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.10.5
TERMUX_PKG_SRCURL=https://github.com/ethereum/go-ethereum/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6f17e0b4a41d321f1017ed6510ab35b447c951b9b1d0d400bfb7a980fac19692

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
