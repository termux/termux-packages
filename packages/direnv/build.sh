TERMUX_PKG_HOMEPAGE=https://github.com/direnv/direnv
TERMUX_PKG_DESCRIPTION="Environment switcher for shell"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.22.0
TERMUX_PKG_SRCURL=https://github.com/direnv/direnv/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=bf35d267a28dcace4109c3256f2cd7cb0ca3b8d461d2fbf848db3f65b809befd
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	make
}

termux_step_make_install() {
	make install DESTDIR=$TERMUX_PREFIX
}
