TERMUX_PKG_HOMEPAGE=https://opentofu.org/
TERMUX_PKG_DESCRIPTION="Open source infrastructure as code tool"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.9"
TERMUX_PKG_SRCURL="https://github.com/opentofu/opentofu/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=acb73b84a4f32150f8a097841fe2c48a2e13d35656ddab4851f46a4d681cdde4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SUGGESTS=git

termux_step_make() {
	termux_setup_golang

	# Alternate toolchains cannot be downloaded in the build environment.
	export GOTOOLCHAIN=local
	export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw"

	local _ldflags="-X github.com/opentofu/opentofu/version.dev=no"
	go build -ldflags "${_ldflags}" -o tofu ./cmd/tofu
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin tofu
}
