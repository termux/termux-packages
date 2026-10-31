TERMUX_PKG_HOMEPAGE=https://github.com/hunspell/hyphen
TERMUX_PKG_DESCRIPTION="hyphenation library to use converted TeX hyphenation patterns"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8.10
TERMUX_PKG_SRCURL=https://github.com/hunspell/hyphen/releases/download/v${TERMUX_PKG_VERSION}/hyphen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a51c876e588108695e88450310d9b3ea9d94d30bcd455c9a2bad2ffed09c1160

termux_step_pre_configure() {
	autoreconf -fvi
}
