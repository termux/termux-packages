TERMUX_PKG_HOMEPAGE=https://luvit.io
TERMUX_PKG_DESCRIPTION="Toolkit for developing, sharing, and running luvit/lua programs and libraries."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8.5
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=git+https://github.com/luvit/lit.git
TERMUX_PKG_GIT_BRANCH=${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="luvi"
TERMUX_PKG_SUGGESTS="luvit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STRIP=true

termux_step_configure() {
	sh "${TERMUX_PKG_SRCDIR}/get-lit.sh"
	mv lit "${TERMUX_PKG_SRCDIR}/_lit"
}

termux_step_make() {
	touch dummy
	./_lit make . ./lit dummy
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/lit"
	unzip -d "${TERMUX_PREFIX}/share/lit" lit

	cat > "${TERMUX_PREFIX}/bin/lit" <<-EOF
	#!${TERMUX_PREFIX}/bin/env bash
	exec luvi ${TERMUX_PREFIX}/share/lit -- \$@
	EOF
	chmod 700 "${TERMUX_PREFIX}/bin/lit"
}
