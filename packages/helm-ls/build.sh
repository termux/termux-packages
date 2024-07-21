TERMUX_PKG_HOMEPAGE=https://github.com/mrjosh/helm-ls
TERMUX_PKG_DESCRIPTION="Language server for Helm"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.19"
TERMUX_PKG_SRCURL=https://github.com/mrjosh/helm-ls/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cb8cf5dc748db1b6399c07f39b06181983e542d4d607f03f0f7c2cb2780bf9a5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	termux_setup_golang

	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
	export GOFLAGS="-buildmode=pie -trimpath -mod=readonly -modcacherw"
	export GOLDFLAGS="-linkmode=external"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" bin/helm_ls
}
