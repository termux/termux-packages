TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_SRCURL=https://github.com/cswl/tsu/archive/ce32547e7ca441ed449b12447539da959b889e95.zip
TERMUX_PKG_SHA256=11c0b0c0b1c9acb64d354ce9b0348d3d950e06e274d567498b1b46e8fd51fb9e
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	:
}

termux_step_make_install () {
	cp tsu $TERMUX_PREFIX/bin/tsu
	chmod +x $TERMUX_PREFIX/bin/tsu

	cp tsudo $TERMUX_PREFIX/bin/tsudo
	chmod +x $TERMUX_PREFIX/bin/tsudo
}
