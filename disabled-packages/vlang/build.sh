TERMUX_PKG_HOMEPAGE=https://github.com/vlang/v
TERMUX_PKG_DESCRIPTION="Simple, fast, safe, compiled language for developing maintainable software"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vlang/v/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9152eec96d2eeb575782cf138cb837f315e48c173878857441d98ba679e3a9bf
TERMUX_PKG_DEPENDS="clang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID=1"

termux_step_make_install() {
	install -Dm700 v "$TERMUX_PREFIX"/libexec/vlang/v
	ln -sfr "$TERMUX_PREFIX"/libexec/vlang/v "$TERMUX_PREFIX"/bin/v
	rm -rf "$TERMUX_PREFIX"/libexec/vlang/vlib
	cp -a cmd vlib "$TERMUX_PREFIX"/libexec/vlang/
}

