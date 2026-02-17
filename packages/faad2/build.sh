TERMUX_PKG_HOMEPAGE=https://github.com/knik0/faad2
TERMUX_PKG_DESCRIPTION="Freeware Advanced Audio (AAC) Decoder"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.2"
TERMUX_PKG_SRCURL="https://github.com/knik0/faad2/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=3fcbd305e4abd34768c62050e18ca0986f7d9c5eca343fb98275418013065c0e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
