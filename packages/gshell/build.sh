TERMUX_PKG_HOMEPAGE=https://github.com/Spectra010s/gshell
TERMUX_PKG_DESCRIPTION="Terminal client for Google Cloud Shell"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Spectra010s"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SRCURL=https://github.com/Spectra010s/gshell/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=55579572fadf07ad63961a985c1c86238b446a7ad73aff3cdb088d54afae3010
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	cd "$TERMUX_PKG_SRCDIR"
	go build -trimpath -ldflags "-s -w -X gshell/cmd.version=${TERMUX_PKG_VERSION}" -o gshell .
}

termux_step_make_install() {
	install -Dm755 gshell "$TERMUX_PREFIX/bin/gshell"
}
