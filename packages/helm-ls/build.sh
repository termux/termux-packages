TERMUX_PKG_HOMEPAGE=https://github.com/mrjosh/helm-ls
TERMUX_PKG_DESCRIPTION="Language server for Helm"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.0"
TERMUX_PKG_SRCURL=https://github.com/mrjosh/helm-ls/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b18897eedc19d20d1dd88f4eb5ac7102042c5fa767bcbc9870700f10537c6128
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
