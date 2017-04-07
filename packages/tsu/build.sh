TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download https://raw.githubusercontent.com/cswl/tsu/075ee39565ea4068b9e216d3f0871507a9e691b1/tsu \
	                $TERMUX_PREFIX/bin/tsu \
	                98606f0bad8cd1407a75cead71d6648b4f5962fb031d27d2eddf0032172d1d7e
	touch $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu
}
