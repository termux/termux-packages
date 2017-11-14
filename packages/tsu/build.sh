TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download https://raw.githubusercontent.com/cswl/tsu/717b902303a9afd546e46722f36feca549376471/tsu \
	                $TERMUX_PREFIX/bin/tsu \
	                519fe419b009b3d9772602255a626c4077cb7b0a5a109b07844fb44d6ec11e9a
	touch $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu
}
