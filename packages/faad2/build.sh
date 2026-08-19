TERMUX_PKG_HOMEPAGE=https://github.com/knik0/faad2
TERMUX_PKG_DESCRIPTION="Freeware Advanced Audio (AAC) Decoder"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.3"
TERMUX_PKG_SRCURL="https://github.com/knik0/faad2/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=860ab62087e336c1844a70e33196c1790b525fb9a9e7b6ac4fab1a1a4e4d5ce8
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
