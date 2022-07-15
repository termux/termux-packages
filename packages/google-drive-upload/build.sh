TERMUX_PKG_HOMEPAGE=https://github.com/labbots/google-drive-upload
TERMUX_PKG_DESCRIPTION="Bash scripts to upload files to google drive"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f841660f9e1d638c36f5cdca4e67a038b030755cb11d6c0dc0996dd305e4da15
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS='bash, curl'
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -D release/bash/* -t "$TERMUX_PREFIX/bin"
}
