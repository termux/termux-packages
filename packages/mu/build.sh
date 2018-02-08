TERMUX_PKG_HOMEPAGE=http://www.djcbsoftware.nl/code/mu/
TERMUX_PKG_DESCRIPTION="Maildir indexer/searcher and Emacs client (mu4e)"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_SRCURL=https://github.com/djcb/mu/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=533149abab967e2809f72e9fe62c6deb71d45b6ad2a5846247733a1dd2de69a0
TERMUX_PKG_DEPENDS="glib, libxapian, libgmime2"
TERMUX_PKG_BUILD_DEPENDS="glib-dev, libxapian-dev, libgmime2-dev"

termux_step_pre_configure() {
	NOCONFIGURE=1	./autogen.sh
}

