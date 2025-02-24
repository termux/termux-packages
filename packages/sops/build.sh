TERMUX_PKG_HOMEPAGE=https://github.com/getsops/sops
TERMUX_PKG_DESCRIPTION="Simple and flexible tool for managing secrets"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.4"
TERMUX_PKG_SRCURL=https://github.com/getsops/sops/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3e0fc9a43885e849eba3b099d3440c3147ad0a0cd5dd77a9ef87c266a8488249
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_make_install() {
	termux_setup_golang

	export GOPATH="${TERMUX_PKG_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/getsops"
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}/src/github.com/getsops/sops"
	cd "${GOPATH}/src/github.com/getsops/sops" || return 9
	go get -d -v

	local d
	for d in ${GOPATH}/pkg/mod/github.com/hashicorp/go-sockaddr*; do
		chmod +w -R "${d}"
		patch --silent -p1 -d "${d}" < "$TERMUX_PKG_BUILDER_DIR/go-sockaddr.diff" || :
	done

	make install

	install -Dm700 "${GOPATH}/bin/"*/sops "${TERMUX_PREFIX}/bin/sops"
}
