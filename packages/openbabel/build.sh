TERMUX_PKG_HOMEPAGE=http://openbabel.org/wiki/Main_Page
TERMUX_PKG_DESCRIPTION="Open Babel is a chemical toolbox designed to speak the many languages of chemical data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.4.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/openbabel/files/openbabel/${TERMUX_PKG_VERSION}/openbabel-${TERMUX_PKG_VERSION}.tar.gz/download
TERMUX_PKG_SHA256=204136582cdfe51d792000b20202de8950218d617fd9c6e18cee36706a376dfc
TERMUX_PKG_DEPENDS="libc++, libcairo, libxml2, eigen"
TERMUX_PKG_BREAKS="openbabel-dev"
TERMUX_PKG_REPLACES="openbabel-dev"

termux_step_pre_configure () {
	export CXXFLAGS="$CXXFLAGS -Wno-c++11-narrowing"
}
