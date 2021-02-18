TERMUX_PKG_HOMEPAGE=https://github.com/hunspell/hyphen
TERMUX_PKG_DESCRIPTION="hyphenation library to use converted TeX hyphenation patterns"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8.8
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/hunspell/hyphen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=304636d4eccd81a14b6914d07b84c79ebb815288c76fe027b9ebff6ff24d5705

termux_step_pre_configure() {
	autoreconf -fvi
} 
