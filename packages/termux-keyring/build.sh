TERMUX_PKG_HOMEPAGE=https://github.com/termux
TERMUX_PKG_DESCRIPTION="GPG public keys for the official Termux repositories"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/trusted.gpg.d

	# Maintainer-specific keys.
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/grimler.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/xeffyr.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/kcubeterm.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/landfillbaby.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/

	# Key for automatic builds (via CI).
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/termux-autobuilds.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/
}
