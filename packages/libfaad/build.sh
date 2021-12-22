
TERMUX_PKG_HOMEPAGE=http://faac.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Freeware Advanced Audio Coder AAC Decoder"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE=GPL-2.0
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_VERSION=2.8.6
_VERSION_REAL=$(echo $(cut -d '.' -f1,2 <<< ${TERMUX_PKG_VERSION}).0)
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/faac/files/faad2-src/faad2-${_VERSION_REAL}/faad2-${TERMUX_PKG_VERSION}.tar.gz/download
TERMUX_PKG_SHA256=654977adbf62eb81f4fca00152aca58ce3b6dd157181b9edd7bed687a7c73f21
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--build=aarch64-unknown-linux-gnu"
termux_step_pre_configure() {
	LDFLAGS=" -lm"
}
