TERMUX_PKG_HOMEPAGE=https://github.com/hunspell/hyphen
TERMUX_PKG_DESCRIPTION="hyphenation library to use converted TeX hyphenation patterns"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8.8-7
TERMUX_PKG_SRCURL=https://github.com/hunspell/hyphen/archive/master.zip
TERMUX_PKG_SHA256=30d9e6f3eb36e84e9e18561990cfaa12220c348ce4eb3630ab58c294dc73a6fe

termux_step_pre_configure() {
 autoreconf -fvi
} 
