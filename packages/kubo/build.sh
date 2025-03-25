TERMUX_PKG_HOMEPAGE=https://ipfs.io/
TERMUX_PKG_DESCRIPTION="A peer-to-peer hypermedia distribution protocol"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.34.1"
TERMUX_PKG_SRCURL=https://github.com/ipfs/kubo/releases/download/v${TERMUX_PKG_VERSION}/kubo-source.tar.gz
TERMUX_PKG_SHA256=c2b02798f7e5b3b2c53b78100484929a7e2e72e5159b3bd8128cfe79573f0393
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SUGGESTS="termux-services"
TERMUX_PKG_SERVICE_SCRIPT=("ipfs" "[ ! -d \"${TERMUX_ANDROID_HOME}/.ipfs\" ] && ipfs init --empty-repo 2>&1 && ipfs config --json Swarm.EnableRelayHop false 2>&1 && ipfs config --json Swarm.EnableAutoRelay true 2>&1; exec ipfs daemon --enable-namesys-pubsub 2>&1")
TERMUX_PKG_CONFLICTS="ipfs"
TERMUX_PKG_REPLACES="ipfs"
TERMUX_PKG_PROVIDES="ipfs"

termux_step_make() {
	termux_setup_golang

	export GOPATH=${TERMUX_PKG_BUILDDIR}

	mkdir -p "${GOPATH}/src/github.com/ipfs"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/ipfs/kubo"
	cd "${GOPATH}/src/github.com/ipfs/kubo"

	make build

	# Fix folders without write permissions preventing which fails repeating builds:
	cd "$TERMUX_PKG_BUILDDIR"
	find . -type d -exec chmod u+w {} \;
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "${TERMUX_PKG_BUILDDIR}/src/github.com/ipfs/kubo/cmd/ipfs/ipfs"
}
