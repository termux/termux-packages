TERMUX_PKG_HOMEPAGE=https://github.com/rizinorg/rz-pm
TERMUX_PKG_DESCRIPTION="package manager of rizin"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.3"
TERMUX_PKG_BUILD_DEPENDS="golang"
TERMUX_PKG_DEPENDS="ninja, clang, cmake"
TERMUX_PKG_SRCURL=https://github.com/rizinorg/rz-pm/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7b5b65ed33500ee588f2cd7017e735d96512316f8024d89af0cd0ebc1ec4e6b8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-compiler=termux-host"

termux_step_pre_configure() {
        rm -f Makefile
}

termux_step_make_install() {
        go build
}

termux_step_post_make_install() {
        install "rz-pm" "$TERMUX_PREFIX/bin"
        "$TERMUX_PREFIX/bin/find" "$TERMUX_PREFIX/bin/" -type f -name 'rz-pm' -exec chmod +x {} \;
}
