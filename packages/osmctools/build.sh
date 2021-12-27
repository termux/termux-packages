TERMUX_PKG_HOMEPAGE=https://gitlab.com/osm-c-tools/osmctools
TERMUX_PKG_DESCRIPTION="Simple tools for OpenStreetMap processing"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.com/osm-c-tools/osmctools/-/archive/${TERMUX_PKG_VERSION}/osmctools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f5298be5b4ba840a04f360c163849b34a31386ccd287657885e21268665f413
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_GROUPS="science"

termux_step_pre_configure () {
	autoreconf --install
}
