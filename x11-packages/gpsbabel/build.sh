TERMUX_PKG_HOMEPAGE=https://www.gpsbabel.org/
TERMUX_PKG_DESCRIPTION="GPS file conversion plus transfer to/from GPS units"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_SRCURL="https://github.com/gpsbabel/gpsbabel/archive/refs/tags/gpsbabel_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=a89756fb988a54f5c5f371413845b9aecb66628a594cd83bd529c0f18382c968
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^gpsbabel_\K\d+(_\d+)+$'
TERMUX_PKG_DEPENDS="libc++, libusb, qt6-qt5compat, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" gpsbabel
}
