TERMUX_PKG_HOMEPAGE=https://wakatime.com/plugins/
TERMUX_PKG_DESCRIPTION="Command line interface used by all WakaTime text editor plugins"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.102.1"
TERMUX_PKG_SRCURL=https://github.com/wakatime/wakatime-cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f822899a697fc67dce895202768c5db9e734d5bbb8382d0a1e43c9c4819ec842
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	rm -f Makefile
	termux_setup_golang

	local _REPO=github.com/wakatime/wakatime-cli
	local _COMMIT=$(git ls-remote https://github.com/wakatime/wakatime-cli refs/tags/v$TERMUX_PKG_VERSION | head -c 7)
	local _DATE=$(date -u '+%Y-%m-%dT%H:%M:%S %Z')
	go build -o wakatime-cli -ldflags="-s -w -X '${_REPO}/pkg/version.BuildDate=${_DATE}' -X '${_REPO}/pkg/version.Commit=${_COMMIT}' -X '${_REPO}/pkg/version.Version=${TERMUX_PKG_VERSION}' -X '${_REPO}/pkg/version.OS=android' -X '${_REPO}/pkg/version.Arch=$(go env GOARCH)'"
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin ${TERMUX_PKG_SRCDIR}/wakatime-cli
}
