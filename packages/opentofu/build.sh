TERMUX_PKG_HOMEPAGE=https://opentofu.org/
TERMUX_PKG_DESCRIPTION="Open source infrastructure as code tool"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11.2
TERMUX_PKG_SRCURL=https://github.com/opentofu/opentofu/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff95091fef8d413938025f7605311cf9b1ef2d1a1a19ee575dafa4ecf5774e0c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="git"

termux_step_make() {
	termux_setup_golang

	# Use the local Go toolchain (downloading alternate toolchains is not supported here).
	export GOTOOLCHAIN=local

	export GOPATH="${TERMUX_PKG_BUILDDIR}"

	mkdir -p "${GOPATH}"/src/github.com/opentofu
	cp -a "${TERMUX_PKG_SRCDIR}" "${GOPATH}"/src/github.com/opentofu/opentofu

	cd "${GOPATH}"/src/github.com/opentofu/opentofu

	local _goversion
	_goversion="$(go env GOVERSION | sed 's/^go//')"
	sed -i "s/^go [0-9.]*$/go ${_goversion}/" go.mod

	local GO_LDFLAGS="-X github.com/opentofu/opentofu/version.dev=no"
	go build -ldflags "${GO_LDFLAGS}" -o tofu ./cmd/tofu
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin \
		"${GOPATH}"/src/github.com/opentofu/opentofu/tofu
}
