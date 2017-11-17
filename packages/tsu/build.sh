TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=0.3
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download https://raw.githubusercontent.com/cswl/tsu/f0d3a5c6d179c34be18fb91b14f2f3da2100365a/tsu \
	                $TERMUX_PREFIX/bin/tsu \
	                e2babd61269765fec16a199b84fbefc3fa852b5d653bae4e52fc1f54b81f4966
	touch $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu
}
