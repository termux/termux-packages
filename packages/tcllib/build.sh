TERMUX_PKG_HOMEPAGE=https://core.tcl-lang.org/tcllib/
TERMUX_PKG_DESCRIPTION="Tcl Standard Library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license.terms"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_SRCURL=https://core.tcl-lang.org/tcllib/uv/tcllib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=642c2c679c9017ab6fded03324e4ce9b5f4292473b62520e82aacebb63c0ce20
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
