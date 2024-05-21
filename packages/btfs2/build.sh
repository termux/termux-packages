TERMUX_PKG_HOMEPAGE=https://www.bittorrent.com/btfs/
TERMUX_PKG_DESCRIPTION="Decentralized file system integrating with TRON network and Bittorrent network"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.5"
TERMUX_PKG_SRCURL=https://github.com/bittorrent/go-btfs/archive/refs/tags/btfs-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bb1f3b659db355e6233ea62e295e01b8404f892c2b87c1bbb6ee8a50105e773e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="btfs"
TERMUX_PKG_REPLACES="btfs"

termux_setup_golang_119() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local TERMUX_GO_VERSION=go1.19.13
		local TERMUX_GO_SHA256=4643d4c29c55f53fa0349367d7f1bb5ca554ea6ef528c146825b0f8464e2e668
		local TERMUX_GO_PLATFORM=linux-amd64

		local TERMUX_BUILDGO_FOLDER="${TERMUX_PKG_CACHEDIR}/${TERMUX_GO_VERSION}"

		export GOROOT=$TERMUX_BUILDGO_FOLDER
		export PATH="${GOROOT}/bin:${PATH}"

		if [ -d "$TERMUX_BUILDGO_FOLDER" ]; then return; fi

		local TERMUX_BUILDGO_TAR=$TERMUX_PKG_CACHEDIR/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz
		rm -Rf "$TERMUX_PKG_CACHEDIR/go" "$TERMUX_BUILDGO_FOLDER"
		termux_download https://golang.org/dl/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz \
			"$TERMUX_BUILDGO_TAR" \
			"$TERMUX_GO_SHA256"

		( cd "$TERMUX_PKG_CACHEDIR"; tar xf "$TERMUX_BUILDGO_TAR";
		( cd go; . ${TERMUX_PKG_BUILDER_DIR}/fix-hardcoded-etc-resolv-conf.sh )
		mv go "$TERMUX_BUILDGO_FOLDER"; rm "$TERMUX_BUILDGO_TAR" )
	else
		termux_error_exit "This package cannot build on device currently."
	fi
}

termux_step_pre_configure() {
	termux_setup_golang_119

	go mod init || :
	go mod tidy
}

termux_step_make() {
	make build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/cmd/btfs/btfs
	ln -sfT btfs $TERMUX_PREFIX/bin/btfs2
}
