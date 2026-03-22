TERMUX_PKG_HOMEPAGE=https://github.com/luqmaan1007-collab/quickgrep
TERMUX_PKG_DESCRIPTION="Smart recursive grep with colored output and match count"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="luqmaan1007-collab"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_SRCURL=https://github.com/luqmaan1007-collab/quickgrep/archive/refs/tags/v1.0.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm700 "$TERMUX_PKG_SRCDIR/quickgrep.sh" "$TERMUX_PREFIX/bin/quickgrep"
}
