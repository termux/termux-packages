TERMUX_PKG_HOMEPAGE=https://luvit.io
TERMUX_PKG_DESCRIPTION="Toolkit for developing, sharing, and running luvit/lua programs and libraries."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8.5
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/luvit/lit.git
TERMUX_PKG_GIT_BRANCH=${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_DEPENDS="luvi"
TERMUX_PKG_SUGGESTS="luvi, luvit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STRIP=true

termux_step_configure() {
	sh "${TERMUX_PKG_SRCDIR}/get-lit.sh"
	mv lit "${TERMUX_PKG_SRCDIR}/_lit"
}

termux_step_make() {
	./_lit make . ./lit "${TERMUX_PREFIX}/bin/luvi"
}

termux_step_make_install() {
	install -Dm700 lit "${TERMUX_PREFIX}/bin/lit"
}
