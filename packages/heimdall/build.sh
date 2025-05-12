TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~grimler/Heimdall
TERMUX_PKG_DESCRIPTION="Tool for flashing firmware onto Samsung Galaxy devices"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @grimler91"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL="https://git.sr.ht/~grimler/Heimdall/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=51276d09acb14cdd7cfca4547ccfa059fa7a4d43fb741afd618c495996a50bfe
TERMUX_PKG_DEPENDS="libprotobuf-c, libusb, termux-api"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DDISABLE_FRONTEND=1"

termux_step_pre_configure() {
	termux_setup_protobuf
}
