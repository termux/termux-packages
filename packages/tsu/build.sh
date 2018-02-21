TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download https://raw.githubusercontent.com/cswl/tsu/ed8940c02ee789ad93f81a443266c45cf2ce3b74/tsu \
	                $TERMUX_PREFIX/bin/tsu \
	                0dd75d7c9a7dc5b7b007a3a8ac08a05040c14199ff336a8b47589345e31e73d1
	touch $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu
}
