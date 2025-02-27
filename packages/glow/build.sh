TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/glow
TERMUX_PKG_DESCRIPTION="Render markdown on the CLI, with pizzazz!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL=https://github.com/charmbracelet/glow/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f1875a73ed81e5d8e6c81443e9a9d18bd9d1489c563c9fa2ff5425f2f8e2af6f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS=git

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR"

	mkdir -p "${TERMUX_PKG_BUILDDIR}/src/github.com/charmbracelet"
	cp -a "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_BUILDDIR}/src/github.com/charmbracelet/glow"
	cd "${TERMUX_PKG_BUILDDIR}/src/github.com/charmbracelet/glow"

	go get -d -v
	go build
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_BUILDDIR}/src/github.com/charmbracelet/glow/glow \
		$TERMUX_PREFIX/bin/glow
}
