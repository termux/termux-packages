TERMUX_PKG_HOMEPAGE=https://gitlab.com/osm-c-tools/osmctools
TERMUX_PKG_DESCRIPTION="Simple tools for OpenStreetMap processing"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_SRCURL=https://gitlab.com/osm-c-tools/osmctools/-/archive/${TERMUX_PKG_VERSION}/osmctools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=af755766fd7168a16727aba122f8e427542c4c52669be1f463002d19c4c04ab1

termux_step_pre_configure () {
	autoreconf --install
}
