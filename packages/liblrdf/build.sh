TERMUX_PKG_HOMEPAGE=https://github.com/swh/LRDF
TERMUX_PKG_DESCRIPTION="A library to make it easy to manipulate RDF files describing LADSPA plugins"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/swh/LRDF/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d579417c477ac3635844cd1b94f273ee2529a8c3b6b21f9b09d15f462b89b1ef
TERMUX_PKG_DEPENDS="libraptor2"

termux_step_pre_configure() {
	autoreconf -fi
}
