TERMUX_PKG_HOMEPAGE=https://github.com/openpubkey/opkssh
TERMUX_PKG_DESCRIPTION="Enables SSH to be used with OpenID Connect"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_SRCURL="https://github.com/openpubkey/opkssh/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b38b6ca60cb97fe9064dfc6aa6fe1969e76d54e0d996114824b5633d6285ee18
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
