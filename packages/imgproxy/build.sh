TERMUX_PKG_HOMEPAGE=https://imgproxy.net
TERMUX_PKG_DESCRIPTION="Fast and secure standalone server for resizing and converting remote images"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.27.2
TERMUX_PKG_SRCURL=https://github.com/imgproxy/imgproxy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9500cc11a87c63c558200f7dc21537ebb0e8ac4dbb55894af99ff5e7a188484
TERMUX_PKG_DEPENDS="glib, libvips"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm,i686"

termux_step_pre_configure() {
	termux_setup_golang
	export CGO_ENABLED=1
	export CGO_LDFLAGS_ALLOW="-s|-w"
	export CGO_CFLAGS_ALLOW="-Xpreprocessor"
}

termux_step_make() {
	go build -o imgproxy -trimpath -ldflags="-checklinkname=0 -s -w"
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/imgproxy
}
