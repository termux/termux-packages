TERMUX_PKG_HOMEPAGE=https://github.com/hunspell/hyphen
TERMUX_PKG_DESCRIPTION="hyphenation library to use converted TeX hyphenation patterns"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8.8
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/hunspell/hyphen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

termux_step_pre_configure() {
	autoreconf -fvi
} 
