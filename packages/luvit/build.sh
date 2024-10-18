TERMUX_PKG_HOMEPAGE=https://luvit.io
TERMUX_PKG_DESCRIPTION="Asynchronous I/O for Lua"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.18.1
TERMUX_PKG_SRCURL=https://github.com/luvit/luvit/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b792781d77028edb7e5761e96618c96162bd68747b8fced9a6fc52f123837c2c
TERMUX_PKG_BUILD_DEPENDS="luvi"
TERMUX_PKG_SUGGESTS="luvi, lit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STRIP=true

termux_step_configure() {
	curl -Lo- https://github.com/luvit/lit/raw/"$(
		source "${TERMUX_SCRIPTDIR}/packages/lit/build.sh"
		echo "${TERMUX_PKG_VERSION}"
	)"/get-lit.sh | sh
	mv lit "${TERMUX_PKG_SRCDIR}/_lit"
}

termux_step_make() {
	./_lit make . ./luvit "${TERMUX_PREFIX}/bin/luvi"
}

termux_step_make_install() {
	install -Dm700 luvit "${TERMUX_PREFIX}/bin/luvit"
}
