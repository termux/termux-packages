TERMUX_PKG_HOMEPAGE=https://github.com/diamondburned/gtkcord4
TERMUX_PKG_DESCRIPTION="GTK4 Discord client in Go"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.4"
TERMUX_PKG_SRCURL=https://github.com/diamondburned/gtkcord4/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=05eb235bf7ddfd026298e217b68cc28ed3502aadac0151c9d6976f1cd3775f56
TERMUX_PKG_DEPENDS="gtk4, libadwaita, gobject-introspection"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -o gtkcord4 -tags libadwaita
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin gtkcord4
}
