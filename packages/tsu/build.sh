TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download https://raw.githubusercontent.com/cswl/tsu/88a8cb09d6fea8e8ed47bd874b5df8ea647302c0/tsu \
	                $TERMUX_PREFIX/bin/tsu \
	                7a71ada4caff54b04e342da74fc211e4bd7dfdf68e7c289673887bcdebcc0b71
	touch $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu
}
