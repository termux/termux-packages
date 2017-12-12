TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	termux_download https://raw.githubusercontent.com/cswl/tsu/7d60aa3479cd2f66c97cc441f022a43371b60523/tsu \
	                $TERMUX_PREFIX/bin/tsu \
	                7d1d4c00b4bbc0f964e8488e9ae964f049665b108cbb3568212e530dbb659c54
	touch $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu
}
