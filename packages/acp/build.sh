TERMUX_PKG_HOMEPAGE=https://github.com/hastagaming/acp
TERMUX_PKG_DESCRIPTION="Git add, commit, and push in one command"
TERMUX_PKG_LONG_DESCRIPTION="Simplify 'git add . && git commit -m && git push' into a single acp command"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@hastagaming"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/hastagaming/acp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=daeda42a3b2140eabdfe79c97ab937dc70a231078c374b41e445b8ed3b47b9f4
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_SUGGEST="openssh"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
    make clean
    make CC="$CC" CFLAGS="$CFLAGS -Wall -Wextra -O2 -std=c11"
}

termux_step_make_install() {
    mkdir -p "$TERMUX_PREFIX/bin"
    install -Dm700 acp "$TERMUX_PREFIX/bin/acp"
    
    mkdir -p "$TERMUX_PREFIX/etc/acp"
    install -Dm644 config/default.conf "$TERMUX_PREFIX/etc/acp/default.conf"
}

