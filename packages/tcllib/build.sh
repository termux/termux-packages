TERMUX_PKG_HOMEPAGE=https://core.tcl-lang.org/tcllib/
TERMUX_PKG_DESCRIPTION="Tcl Standard Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license.terms"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.21
TERMUX_PKG_SRCURL=https://core.tcl-lang.org/tcllib/uv/tcllib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=10c7749e30fdd6092251930e8a1aa289b193a3b7f1abf17fee1d4fa89814762f
TERMUX_PKG_DEPENDS="tcl"
TERMUX_PKG_RECOMMENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
	true
}

termux_step_make() {
	true
}

termux_step_make_install() {
	tclsh installer.tcl \
		-pkg-path ${TERMUX_PREFIX}/lib/tcllib${TERMUX_PKG_VERSION} \
		-app-path ${TERMUX_PREFIX}/bin \
		-nroff-path ${TERMUX_PREFIX}/share/man/mann \
		-no-examples \
		-no-html \
		-no-wait \
		-no-gui
}
