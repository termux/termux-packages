TERMUX_PKG_HOMEPAGE=https://github.com/direnv/direnv
TERMUX_PKG_DESCRIPTION="Environment switcher for shell"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.21.2
TERMUX_PKG_SRCURL=https://github.com/direnv/direnv/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ce5551b09f71fe26111bbf94a09cfdbce14794ec9a723015b67efea804986d68
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	make
}

termux_step_make_install() {
	make install DESTDIR=$TERMUX_PREFIX
}
