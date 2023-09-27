TERMUX_PKG_HOMEPAGE="https://www.nongnu.org/atool"
TERMUX_PKG_DESCRIPTION="tool for managing file archives of various types"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.39.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.savannah.gnu.org/releases/atool/atool-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256="aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS="arj, binutils-is-llvm | binutils, bzip2, cpio, file, gzip, lhasa, lzip, lzop, p7zip, tar, unrar, unzip, xz-utils, zip"
TERMUX_PKG_SUGGESTS="bash-completion"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/share/bash-completion/completions"
	install -Dm600 "extra/bash-completion-atool_0.1-1" \
		"$TERMUX_PREFIX/share/bash-completion/completions/atool"
}
