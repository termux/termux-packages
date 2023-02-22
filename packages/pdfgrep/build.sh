TERMUX_PKG_HOMEPAGE=https://pdfgrep.org/
TERMUX_PKG_DESCRIPTION="Command line utility to search text in PDF files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://pdfgrep.org/download/pdfgrep-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0ef3dca1d749323f08112ffe68e6f4eb7bc25f56f90a2e933db477261b082aba
TERMUX_PKG_DEPENDS="libc++, libgcrypt, libgpg-error, pcre, poppler"

termux_step_pre_configure() {
	CXXFLAGS+=" -std=c++17"
}
