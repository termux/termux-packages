TERMUX_PKG_HOMEPAGE=https://bundles.openttdcoop.org/openmsx
TERMUX_PKG_DESCRIPTION="Free music set for openttd"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.3.1
TERMUX_PKG_REVISION=21
TERMUX_PKG_SRCURL=https://cdn.openttd.org/openmsx-releases/$TERMUX_PKG_VERSION/openmsx-$TERMUX_PKG_VERSION-all.zip
TERMUX_PKG_SHA256=92e293ae89f13ad679f43185e83fb81fb8cad47fe63f4af3d3d9f955130460f5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -d "$TERMUX_PREFIX"/share/openttd/data
	install -m600 openmsx.obm "$TERMUX_PREFIX"/share/openttd/data
	install -m600 *.mid "$TERMUX_PREFIX"/share/openttd/data
}
