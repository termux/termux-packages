TERMUX_PKG_HOMEPAGE=https://www.gap-system.org/
TERMUX_PKG_DESCRIPTION="GAP is a system for computational discrete algebra, with particular emphasis on Computational Group Theory"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.11.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/gap-system/gap/releases/download/v${TERMUX_PKG_VERSION}/gap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6635c5da7d82755f8339486b9cac33766f58712f297e8234fba40818902ea304
TERMUX_PKG_DEPENDS="readline, libgmp, zlib"
TERMUX_PKG_BREAKS="gap-dev"
TERMUX_PKG_REPLACES="gap-dev"

termux_step_post_make_install() {
	ln -sf $TERMUX_PREFIX/bin $TERMUX_PREFIX/share/gap/
}
