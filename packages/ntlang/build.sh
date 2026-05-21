TERMUX_PKG_HOMEPAGE=https://github.com/megamexlevi2/ntl-lang-gz
TERMUX_PKG_DESCRIPTION="NTL programming language"
TERMUX_PKG_LICENSE="NTL-Source-License-1.0"
TERMUX_PKG_MAINTAINER="David Dev"
TERMUX_PKG_VERSION=0.4.0

TERMUX_PKG_SRCURL=https://github.com/Megamexlevi2/ntl-lang-gz/releases/download/0.4.0/ntl-aarch64.tar.gz

TERMUX_PKG_SHA256=a4ca073bf8156af3c1315b0aa66cba4ffc2f5f36cd34a7aeedd34c14f07d1cc3

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 ntl $TERMUX_PREFIX/bin/ntl
}