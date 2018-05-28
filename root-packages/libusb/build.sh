TERMUX_PKG_HOMEPAGE=http://libusb.info/
TERMUX_PKG_DESCRIPTION="A cross-platform user library to access USB devices"
TERMUX_PKG_VERSION=1.0.22
TERMUX_PKG_SRCURL=https://github.com/libusb/libusb/archive/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=cb10afc04399f5aa15cce246e5f043bea3547d128f088d62874039f984db7879
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-udev"

termux_step_pre_configure() {
	NOCONFIGURE=true ./autogen.sh
}
