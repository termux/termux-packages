TERMUX_PKG_HOMEPAGE=https://ipfs.io/
TERMUX_PKG_DESCRIPTION="A peer-to-peer hypermedia distribution protocol"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.12.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ipfs/go-ipfs/releases/download/v${TERMUX_PKG_VERSION}/go-ipfs-source.tar.gz
TERMUX_PKG_SHA256=eba34d2cc49f7811d087f4259c44c1fecb2b6bd08a6c3fa3b5a26e5fed78c74d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SUGGESTS="termux-services"
TERMUX_PKG_SERVICE_SCRIPT=("ipfs" "[ ! -d \"${TERMUX_ANDROID_HOME}/.ipfs\" ] && ipfs init --empty-repo 2>&1 && ipfs config --json Swarm.EnableRelayHop false 2>&1 && ipfs config --json Swarm.EnableAutoRelay true 2>&1; exec ipfs daemon --enable-namesys-pubsub 2>&1")

termux_step_make() {
	termux_setup_golang

	export GOPATH=${TERMUX_PKG_BUILDDIR}

	mkdir -p "${GOPATH}/src/github.com/ipfs"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ipfs/go-ipfs"
	cd "${GOPATH}/src/github.com/ipfs/go-ipfs"

	# Needed to build against go 1.18.
	# TODO: Remove after https://github.com/ipfs/go-ipfs/issues/8819 is resolved.
	go get github.com/lucas-clemente/quic-go@v0.26.0
	go mod edit -go=1.18 # qo-qtls needs go 1.18
	go mod tidy && go mod vendor

	make build

	# Fix folders without write permissions preventing which fails repeating builds:
	cd $TERMUX_PKG_BUILDDIR
	find . -type d -exec chmod u+w {} \;
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "${TERMUX_PKG_BUILDDIR}/src/github.com/ipfs/go-ipfs/cmd/ipfs/ipfs"
}
