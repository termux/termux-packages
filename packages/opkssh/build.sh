TERMUX_PKG_HOMEPAGE=https://github.com/openpubkey/opkssh
TERMUX_PKG_DESCRIPTION="Enables SSH to be used with OpenID Connect"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.0"
TERMUX_PKG_SRCURL="https://github.com/openpubkey/opkssh/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=036287cf27ce2baa3715fe917e2d6b300a499ee8766c1895bfb708690162502c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-ldflags "-s -w -X main.Version=$TERMUX_PKG_VERSION" \
		-o opkssh .
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "${TERMUX_PKG_SRCDIR}"/opkssh
}
