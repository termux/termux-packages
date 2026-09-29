TERMUX_PKG_HOMEPAGE=https://github.com/knik0/faad2
TERMUX_PKG_DESCRIPTION="Freeware Advanced Audio (AAC) Decoder"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.4"
TERMUX_PKG_SRCURL="https://github.com/knik0/faad2/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=ee479ccbae4a8387ab696e6f21a481bd83fe3881471cafa81b4ae59d7d3aed43
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
