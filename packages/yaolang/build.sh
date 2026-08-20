# License: MIT
TERMUX_PKG_HOMEPAGE=https://yaolang.l.cd
TERMUX_PKG_DESCRIPTION="YaoLang - A system programming language with 100% Chinese keywords"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="YaoLang Team"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_SRCURL=https://github.com/a737812/yaolang/archive/refs/tags/v${TERMUX_PKG_VERSION}-alpha.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="clang, make"
TERMUX_PKG_HOSTBUILD=true

termux_step_make() {
    cc -O2 -o yaolang src/yaolang.c -lm
}

termux_step_make_install() {
    install -Dm700 yaolang ${TERMUX_PREFIX}/bin/yaolang
    install -Dm600 README.md ${TERMUX_PREFIX}/share/doc/yaolang/README.md
    cp -r docs/ ${TERMUX_PREFIX}/share/doc/yaolang/
}
