TERMUX_PKG_HOMEPAGE="https://github.com/Wilfred/difftastic"
TERMUX_PKG_DESCRIPTION="difft: A structural diff that understands syntax"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.67.0"
TERMUX_PKG_SRCURL="https://github.com/Wilfred/difftastic/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=a6a15d6ca9f9ab7c034d1770417d1829deb3fbe9dcf4731b9cba867e50e78437
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
# needed for MIME database (optional in upstream)
TERMUX_PKG_RECOMMENDS="file"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_make_install() {
	install -Dm644 -t "$TERMUX_PREFIX/share/man/man1/" difft.1
}
