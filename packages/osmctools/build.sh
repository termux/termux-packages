TERMUX_PKG_HOMEPAGE=https://gitlab.com/osm-c-tools/osmctools
TERMUX_PKG_DESCRIPTION="Simple tools for OpenStreetMap processing."
TERMUX_PKG_LICENSE="agplv3"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_SRCURL=https://gitlab.com/osm-c-tools/osmctools/-/archive/master/osmctools-master.tar.gz
TERMUX_PKG_SHA256=af755766fd7168a16727aba122f8e427542c4c52669be1f463002d19c4c04ab1

termux_step_post_extract_package () {
	mv COPYING LICENSE
}
