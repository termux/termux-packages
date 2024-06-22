TERMUX_PKG_HOMEPAGE=https://github.com/charmbracelet/glow
TERMUX_PKG_DESCRIPTION="Render markdown on the CLI, with pizzazz!"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/charmbracelet/glow/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b4ecf269b7c6447e19591b1d23f398ef2b38a6a75be68458390b42d3efc44b92
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
