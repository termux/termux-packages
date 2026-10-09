TERMUX_PKG_HOMEPAGE=https://unfs3.github.io/
TERMUX_PKG_DESCRIPTION="User-space implementation of the NFSv3 server specification"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL="https://github.com/unfs3/unfs3/archive/refs/tags/unfs3-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=563359f4e336d89f3f04361555ff4483acb951b1442a067407a19214410668c6
TERMUX_PKG_DEPENDS="libtirpc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SERVICE_SCRIPT=("unfsd" "exec unfsd 2>&1")

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	install -Dm644 "${TERMUX_PKG_BUILDER_DIR}/unfsd.conf" "$TERMUX_PREFIX/etc/conf.d/unfsd.conf"
}
