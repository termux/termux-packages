TERMUX_PKG_HOMEPAGE=https://github.com/hunspell/hyphen
TERMUX_PKG_DESCRIPTION="hyphenation library to use converted TeX hyphenation patterns"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8.9
TERMUX_PKG_SRCURL=https://github.com/hunspell/hyphen/releases/download/v${TERMUX_PKG_VERSION}/hyphen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=783743daf477de8c4d16e3c74b4d2827377017718d8e17e2d9440210246f6abe

termux_step_pre_configure() {
	autoreconf -fvi
}
