TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/hexyl
TERMUX_PKG_DESCRIPTION="A command-line hex viewer"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sharkdp/hexyl/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=52853b4edede889b40fd6ff132e1354d957d1f26ee0c26ebdea380f8ce82cb0b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}"/share/man/man1
	pandoc --standalone --to man doc/hexyl.1.md --output "${TERMUX_PREFIX}"/share/man/man1/hexyl.1
}
