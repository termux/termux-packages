TERMUX_PKG_HOMEPAGE=https://github.com/sipeed/picoclaw
TERMUX_PKG_DESCRIPTION="Ultra-lightweight personal AI agent for messaging channels"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@imguoguo"
TERMUX_PKG_VERSION="0.2.0"
TERMUX_PKG_SRCURL=https://github.com/sipeed/picoclaw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2b24db59ee2798d07ee9ad931826e9f7550f6bb8b0e0fd48dec20730e37d51d3
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	go generate ./...

	go build \
		-trimpath \
		-mod=readonly \
		-modcacherw \
		-tags stdjson \
		-ldflags "\
		-s -w \
		-X github.com/sipeed/picoclaw/cmd/picoclaw/internal.version=${TERMUX_PKG_VERSION} \
		-X github.com/sipeed/picoclaw/cmd/picoclaw/internal.gitCommit=${TERMUX_PKG_VERSION} \
		-X github.com/sipeed/picoclaw/cmd/picoclaw/internal.buildTime=$(date --date=@${SOURCE_DATE_EPOCH} -u +%Y-%m-%dT%H:%M:%SZ) \
		" \
		-o "${TERMUX_PKG_BUILDDIR}/picoclaw" \
		./cmd/picoclaw

	go build \
		-trimpath \
		-mod=readonly \
		-modcacherw \
		-tags stdjson \
		-ldflags "-s -w" \
		-o "${TERMUX_PKG_BUILDDIR}/picoclaw-launcher" \
		./cmd/picoclaw-launcher

	go build \
		-trimpath \
		-mod=readonly \
		-modcacherw \
		-tags stdjson \
		-ldflags "-s -w" \
		-o "${TERMUX_PKG_BUILDDIR}/picoclaw-launcher-tui" \
		./cmd/picoclaw-launcher-tui
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_BUILDDIR}/picoclaw" "${TERMUX_PREFIX}/bin/picoclaw"
	install -Dm700 "${TERMUX_PKG_BUILDDIR}/picoclaw-launcher" "${TERMUX_PREFIX}/bin/picoclaw-launcher"
	install -Dm700 "${TERMUX_PKG_BUILDDIR}/picoclaw-launcher-tui" "${TERMUX_PREFIX}/bin/picoclaw-launcher-tui"
}
