TERMUX_PKG_HOMEPAGE=https://github.com/OwO-Network/nexttrace-enhanced
TERMUX_PKG_DESCRIPTION="An open source visual routing tool that pursues light weight"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.0-beta.3"
TERMUX_PKG_SRCURL=https://github.com/OwO-Network/nexttrace-enhanced/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45f1e37058dec820722f6dd7db2eb0254eceeb5602f6faa91a9ce4fbe0c551a6
TERMUX_PKG_REVISION=1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	export CGO_ENABLED=0
	local _COMMIT_SHA1="$(git ls-remote https://github.com/OwO-Network/nexttrace-enhanced refs/tags/v${TERMUX_PKG_VERSION} | head -c 7)"
	local _BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

	ldflags=" -w -s \
	-X 'github.com/OwO-Network/nexttrace-enhanced/printer.version=${TERMUX_PKG_VERSION}' \
	-X 'github.com/OwO-Network/nexttrace-enhanced/printer.buildDate=${_BUILD_DATE}' \
	-X 'github.com/OwO-Network/nexttrace-enhanced/printer.commitID=${_COMMIT_SHA1}'"

	go build -trimpath -o nexttrace -ldflags "${ldflags}"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin nexttrace
}
