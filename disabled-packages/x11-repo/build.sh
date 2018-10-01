TERMUX_PKG_HOMEPAGE=https://termux-x11.ml
TERMUX_PKG_DESCRIPTION="Package repository with programs and libraries for the X Windowing System"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/apt/{sources.list.d,trusted.gpg.d}
	echo "deb https://termux-x11.ml x11 main" > $TERMUX_PREFIX/etc/apt/sources.list.d/x11.list
	cp $TERMUX_PKG_BUILDER_DIR/xeffyr.gpg $TERMUX_PREFIX/etc/apt/trusted.gpg.d/xeffyr.gpg
}
