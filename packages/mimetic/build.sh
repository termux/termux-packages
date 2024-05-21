TERMUX_PKG_HOMEPAGE=https://www.codesink.org/mimetic_mime_library.html
TERMUX_PKG_DESCRIPTION="A C++ Email library (MIME)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.codesink.org/download/mimetic-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a07d68d125f5e132949b078c7275d5eb0078dd649079bd510dd12b969096700
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
