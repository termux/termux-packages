TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download https://raw.githubusercontent.com/cswl/tsu/c0a2603b57511a1492dfe6ec4e6ef452e01a58e6/tsu \
	                $TERMUX_PREFIX/bin/tsu \
	                ee33a58fd19bfc6c99aab8af4c836ede4b749b4f1ca5957cbb66503828bec7c7
	termux_download https://raw.githubusercontent.com/cswl/tsu/c0a2603b57511a1492dfe6ec4e6ef452e01a58e6/tsudo \
					$TERMUX_PREFIX/bin/tsudo \
					275d025ce7e241f989fcbb1d12f49ed9ab927b3b0e8a1a41de2a89fc1bfee6b0
	touch $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu
	touch $TERMUX_PREFIX/bin/tsudo
	chmod +x $TERMUX_PREFIX/bin/tsudo
}
