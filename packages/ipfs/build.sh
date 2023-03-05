TERMUX_PKG_HOMEPAGE=https://ipfs.io/
TERMUX_PKG_DESCRIPTION="A peer-to-peer hypermedia distribution protocol"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=d1541e1d30589619525f53e799e45d00e42896bb
_COMMIT_DATE=20230303
TERMUX_PKG_VERSION=0.18.1-p${_COMMIT_DATE}
#TERMUX_PKG_SRCURL=https://github.com/ipfs/kubo/releases/download/v${TERMUX_PKG_VERSION}/kubo-source.tar.gz
TERMUX_PKG_SRCURL=git+https://github.com/ipfs/kubo
TERMUX_PKG_SHA256=8a82b7a687925d14f056aeed7354e2277542936c29b02ba6444c500bbb4eef5f
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SUGGESTS="termux-services"
TERMUX_PKG_SERVICE_SCRIPT=("ipfs" "[ ! -d \"${TERMUX_ANDROID_HOME}/.ipfs\" ] && ipfs init --empty-repo 2>&1 && ipfs config --json Swarm.EnableRelayHop false 2>&1 && ipfs config --json Swarm.EnableAutoRelay true 2>&1; exec ipfs daemon --enable-namesys-pubsub 2>&1")

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

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
