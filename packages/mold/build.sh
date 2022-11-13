TERMUX_PKG_HOMEPAGE=https://github.com/rui314/mold
TERMUX_PKG_DESCRIPTION="mold: A Modern Linker"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.0"
TERMUX_PKG_SRCURL=https://github.com/rui314/mold/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ccd685afcdb7047f8a8ce8b5ce3b3cd22205a0ebc548ff1f1da7b35415fafbe4
TERMUX_PKG_DEPENDS="libc++, openssl, zlib, libandroid-spawn"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--no-as-needed -dl -landroid-spawn"
}
